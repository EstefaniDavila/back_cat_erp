require 'net/http'
require 'uri'
require 'json'

class Api::V1::SupportController < ApplicationController
  skip_before_action :authenticate_user! if respond_to?(:authenticate_user!)

  def classify_incident
    begin
      description = params[:description]
      
      if description.blank?
        return render json: { error: 'La descripción es obligatoria' }, status: :unprocessable_entity
      end

    api_key = ENV['CLAUDE_API_KEY']
    
    unless api_key
      return render json: { error: 'Falta configurar CLAUDE_API_KEY' }, status: :internal_server_error
    end

    system_prompt = <<~PROMPT
      Eres un Ingeniero de Nivel 1 de Soporte TI para el ERP CAT (Caterpillar).
      Tu tarea es clasificar el reporte de incidente del usuario estrictamente bajo estas reglas ITIL:

      **Módulos Posibles:** "Ventas", "Logística y Almacén", "Producción y Operaciones", "Gerencia General", "Infraestructura".
      
      **Severidad y SLAs:**
      - P1 (Crítico): Caída del VPS, Base de datos caída, error de autenticación JWT (todos afectados), frontend Vercel inaccesible. (SLA: <= 15 min respuesta, <= 2 horas resolución).
      - P2 (Alto): Falla un módulo completo pero el resto opera (ej: no registrar cotizaciones, alertas mantenimiento no se envían, dashboard sin datos). (SLA: <= 1 hora respuesta, <= 8 horas resolución).
      - P3 (Medio): Falla específica pero con alternativas (ej: reportes con datos duplicados, lentitud). (SLA: <= 4 horas respuesta).
      - P4 (Bajo): Impacto menor, visual o de usabilidad (textos incorrectos, íconos rotos). (SLA: <= 24 horas respuesta).

      Devuelve ÚNICAMENTE un objeto JSON válido con la siguiente estructura, sin texto adicional antes ni después:
      {
        "severity": "critical|high|medium|low",
        "severity_label": "P1 (Crítico) | P2 (Alto) | P3 (Medio) | P4 (Bajo)",
        "module": "Nombre del Módulo Afectado",
        "sla_response": "Tiempo de respuesta",
        "analysis": "Breve justificación de 1 línea",
        "steps": "Lista enumerada de pasos lógicos para reproducir el error extraídos de la descripción. Ejemplo:\n1. Hacer X\n2. Ir a Y"
      }
    PROMPT

    uri = URI.parse("https://api.anthropic.com/v1/messages")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["x-api-key"] = api_key
    request["anthropic-version"] = "2023-06-01"

    request.body = JSON.dump({
      "model" => "claude-sonnet-5",
      "max_tokens" => 500,
      "system" => system_prompt,
      "messages" => [
        {
          "role" => "user",
          "content" => "Incidente reportado: #{description}"
        }
      ]
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      begin
        body = JSON.parse(response.body)
        text_block = body["content"].find { |b| b["type"] == "text" }
        claude_text = text_block ? text_block["text"] : ""
        
        json_match = claude_text.match(/\{.*\}/m)
        if json_match
          classification = JSON.parse(json_match[0])
          render json: classification, status: :ok
        else
          render json: { error: 'Claude no devolvió un JSON válido', raw: claude_text }, status: :unprocessable_entity
        end
      rescue => e
        Rails.logger.error "JSON Parse error: #{e.message}. Raw text: #{claude_text}"
        render json: { error: "Error procesando la respuesta: #{e.message}" }, status: :internal_server_error
      end
      else
        Rails.logger.error "Claude API error (#{response.code}): #{response.body}"
        render json: { error: 'Error de conexión con Claude API', details: response.body }, status: :internal_server_error
      end
    rescue Exception => e
      Rails.logger.error "ERROR CLAUDE: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Excepción del servidor: #{e.class} - #{e.message}" }, status: :internal_server_error
    end
  end
end
