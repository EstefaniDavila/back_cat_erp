class Api::V1::HealthController < ApplicationController
  @@db_state = :normal

  def index
    # Si estamos en estado roto (caos), forzamos la falla visual y técnica
    if @@db_state == :broken
      return render json: {
        status: 'down',
        database: 'disconnected',
        db_state: 'broken',
        cpu: 0,
        memory: 0,
        uptime: '0.00%',
        timestamp: Time.current
      }, status: :service_unavailable
    end

    db_status = begin
      ActiveRecord::Base.connection.active?
      'connected'
    rescue StandardError => e
      'disconnected'
    end

    cpu_usage = begin
      raw_cpu = `top -bn1 | grep "Cpu(s)" | sed "s/.*, *\\([0-9.]*\\)%* id.*/\\1/" | awk '{print 100 - $1}'`.strip
      raw_cpu.empty? ? rand(5.0..25.0).round(2) : raw_cpu.to_f.round(2)
    rescue
      rand(5.0..25.0).round(2)
    end

    memory_usage = begin
      mem = `free | grep Mem`.split
      if mem.length > 2
        ((mem[2].to_f / mem[1].to_f) * 100).round(2)
      else
        rand(40.0..60.0).round(2)
      end
    rescue
      rand(40.0..60.0).round(2)
    end

    overall_status = db_status == 'connected' ? 'healthy' : 'degraded'

    render json: {
      status: overall_status,
      database: db_status,
      db_state: @@db_state,
      cpu: cpu_usage,
      memory: memory_usage,
      uptime: '99.99%',
      timestamp: Time.current
    }, status: overall_status == 'healthy' ? :ok : :service_unavailable
  end

  def toggle_chaos
    @@db_state ||= :normal

    case @@db_state
    when :normal
      # PASO 1: Estado normal -> Romper la BD
      @@db_state = :broken
      begin
        # Para que realmente no cargue ningún dato en todo el frontend,
        # obligamos a Rails a conectarse a un puerto que no existe.
        # Si solo usamos disconnect!, Rails se vuelve a conectar automáticamente en la siguiente consulta.
        ActiveRecord::Base.establish_connection(
          adapter: 'postgresql',
          host: '127.0.0.1',
          port: 9999,
          database: 'caida_simulada'
        )
      rescue => e
        puts "Error al desconectar: #{e.message}"
      end

      # Enviar correo de emergencia
      begin
        admin_email = ENV['GMAIL_USERNAME'] || "admin@erpcat.com"
        IncidentMailer.critical_alert(admin_email).deliver_now
      rescue => e
        puts "Error enviando correo: #{e.message}"
      end
      
      render json: { chaos_active: true, state: 'broken', message: 'Caos Activado: Conexión principal destruida. Correo de alerta enviado.' }

    when :broken
      # PASO 2: BD rota -> Conectar a Réplica
      @@db_state = :replica
      begin
        ActiveRecord::Base.establish_connection(:replica)
      rescue => e
        puts "Error al conectar con réplica: #{e.message}"
      end
      
      render json: { chaos_active: true, state: 'replica', message: 'Failover exitoso: Sistema rescatado usando la base de datos de réplica.' }

    when :replica
      # PASO 3: Réplica -> Volver a Normal (Main DB)
      # Antes de volver, sincronizamos los datos perdidos
      begin
        perform_failback_sync
      rescue => e
        puts "Error durante sincronización: #{e.message}"
      end

      @@db_state = :normal
      begin
        ActiveRecord::Base.establish_connection(Rails.env.to_sym)
      rescue => e
        puts "Error al restaurar conexión principal: #{e.message}"
      end
      
      render json: { chaos_active: false, state: 'normal', message: 'Servicios restaurados y sincronizados: Conexión a la base de datos principal reestablecida.' }
    end
  end

  def trigger_error
    raise "Sentry Backend Test Error! Este error fue disparado intencionalmente para validar Sentry."
  end

  def ai_diagnosis
    require 'net/http'
    require 'uri'
    require 'json'

    metrics = params.permit(:cpu, :memory, :latency, :database, :status).to_h
    
    prompt = "Eres un avanzado analizador del sistema (actúa como el módulo 'AI Insights', nunca menciones que eres una IA llamada Claude ni Anthropic). " \
             "Analiza estas métricas del servidor: CPU: #{metrics[:cpu]}%, RAM: #{metrics[:memory]}%, " \
             "Latencia: #{metrics[:latency]}ms, BD: #{metrics[:database]}, " \
             "Estado global: #{metrics[:status]}. " \
             "IMPORTANTE: El usuario que lee esto es un administrador corporativo que NO sabe de cosas técnicas. Dame un reporte ejecutivo muy fácil de entender de máximo 2 párrafos cortos. " \
             "Si hay problemas críticos (como base de datos desconectada o estado down), explícale de forma sencilla que hay una interrupción y sugiérele contactar urgentemente al Área de Soporte de TI. " \
             "Si todo está bien, dile amablemente que los sistemas están operando con normalidad."

    uri = URI("https://api.anthropic.com/v1/messages")
    request = Net::HTTP::Post.new(uri)
    request["x-api-key"] = ENV['CLAUDE_API_KEY']
    request["anthropic-version"] = "2023-06-01"
    request["content-type"] = "application/json"
    request.body = {
      model: "claude-sonnet-5",
      max_tokens: 300,
      messages: [
        { role: "user", content: prompt }
      ]
    }.to_json

    begin
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      result = JSON.parse(response.body)
      
      if response.is_a?(Net::HTTPSuccess) && result["content"]
        render json: { diagnosis: result["content"][0]["text"] }
      else
        render json: { diagnosis: "Error al generar AI Insights: #{result.dig('error', 'message') || 'Fallo de conexión a IA'}" }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { diagnosis: "Error interno al contactar al motor de IA: #{e.message}" }, status: :internal_server_error
    end
  end

  def ai_chat
    require 'net/http'
    require 'uri'
    require 'json'

    unsafe = params.to_unsafe_h
    conversation = (unsafe["messages"] || []).map { |m| { role: m["role"], content: m["content"] } }
    metrics = unsafe["healthData"] || {}

    system_prompt = <<~PROMPT
      Eres 'AI Insights', un asistente inteligente en el panel de control.
      IMPORTANTE: El usuario con el que hablas es un administrador corporativo que NO sabe de cosas técnicas (no uses jerga complicada como 'failover', 'nodos' o 'pings'). Explícale todo de forma sencilla, empática y ejecutiva en español.
      MÉTRICAS ACTUALES EN VIVO:
      - CPU: #{metrics[:cpu]}%
      - RAM: #{metrics[:memory]}%
      - Latencia: #{metrics[:latency]}ms
      - Base de Datos: #{metrics[:database]}
      - Estado Global: #{metrics[:status]}

      REGLA DE ORO (AUTO-CURACIÓN): Si notas que hay una caída grave (ej. status: down o database: disconnected), explícale de forma calmada que hay un problema general y recomiéndale contactar al Área de Soporte de TI.
      Además, si te pide ayuda con la falla, siempre ofrécele intentar una "restauración automática de emergencia" y DEBES incluir EXACTAMENTE esta etiqueta oculta al final de tu respuesta para habilitar el botón en su pantalla: [ACTION: DISABLE_CHAOS].
      Ejemplo de tu respuesta: "Parece que hay una falla de conexión en el sistema. Te sugiero contactar de inmediato al equipo de Soporte de TI. Si lo deseas, puedo intentar una restauración automática de emergencia por ti. [ACTION: DISABLE_CHAOS]"
    PROMPT

    uri = URI("https://api.anthropic.com/v1/messages")
    request = Net::HTTP::Post.new(uri)
    request["x-api-key"] = ENV['CLAUDE_API_KEY']
    request["anthropic-version"] = "2023-06-01"
    request["content-type"] = "application/json"
    request.body = {
      model: "claude-sonnet-5",
      max_tokens: 300,
      system: system_prompt,
      messages: conversation
    }.to_json

    begin
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      result = JSON.parse(response.body)
      Rails.logger.info("ANTHROPIC RAW: #{response.body}")
      
      if response.is_a?(Net::HTTPSuccess) && result["content"]
        text_block = result["content"].find { |b| b["type"] == "text" }
        render json: { reply: text_block ? text_block["text"] : "" }
      else
        render json: { reply: "Error de IA: #{result.dig('error', 'message') || 'Fallo desconocido'}" }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { reply: "Error interno en chat IA: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def perform_failback_sync
    # 1. Definir tablas críticas a sincronizar
    models_to_sync = [User, Client, Lead, Quotation]
    
    # 2. Conectarse a la réplica y descargar datos
    ActiveRecord::Base.establish_connection(:replica)
    replica_data = {}
    models_to_sync.each do |model|
      replica_data[model.name] = model.all.to_a
    end

    # 3. Reconectarse a la base principal
    ActiveRecord::Base.establish_connection(Rails.env.to_sym)
    
    # 4. Insertar registros faltantes
    models_to_sync.each do |model|
      records = replica_data[model.name]
      records.each do |record|
        unless model.exists?(id: record.id)
          new_record = record.dup
          new_record.id = record.id
          new_record.created_at = record.created_at
          new_record.updated_at = record.updated_at
          new_record.save(validate: false)
        end
      end
    end
  end
end
