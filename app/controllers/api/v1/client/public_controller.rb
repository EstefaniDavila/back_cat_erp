class Api::V1::Client::PublicController < ApplicationController
  # Este controlador NO debe tener `before_action :authenticate_user`
  # porque es público para la Landing Page
  
  def request_quote
    ActiveRecord::Base.transaction do
      # 1. Buscar si el cliente ya existe por ID, email o documento
      client = nil
      client = Client.find_by(id: params[:client_id]) if params[:client_id].present?
      client ||= Client.find_by(email: params[:email])
      client ||= Client.find_by(document_number: params[:document_number]) if params[:document_number].present?
      is_new_client = false

      if client.nil?
        is_new_client = true
        # Crear el nuevo Cliente
        client = Client.create!(
          business_name: params[:business_name],
          contact_name: params[:contact_name],
          document_number: params[:document_number] || "DNI-#{SecureRandom.hex(4)}",
          document_type: params[:document_type] || 'DNI',
          email: params[:email],
          phone: params[:phone],
          status: 'active'
        )

        # Generar contraseña aleatoria de 8 caracteres
        generated_password = SecureRandom.alphanumeric(8)

        # Crear su cuenta de Usuario para el Portal
        user = User.create!(
          email: client.email,
          password: generated_password,
          document_number: client.document_number,
          roleable: client,
          status: 'active'
        )

        # Enviar correo de bienvenida
        # ClientMailer.welcome_email(user, generated_password).deliver_later
      end

      # 2. Crear el Lead (Prospecto) para que el Manager lo asigne
      default_advisor = Advisor.find_or_initialize_by(email: "sistema@erpcat.com") do |a|
        a.first_name = "Por"
        a.last_name = "Asignar"
        a.full_name = "Por Asignar"
        a.document_number = "00000000"
        a.document_type = "DNI"
        a.code = "ADV-0000"
        a.status = "active"
      end
      default_advisor.save(validate: false) if default_advisor.new_record?

      # Construir notas detalladas de alquiler/servicio si están presentes
      notes_content = []
      if params[:type] == 'rental' || params[:type] == 'maintenance' || params[:type] == 'Alquiler' || params[:type] == 'Mantenimiento'
        notes_content << "📅 PLANIFICACIÓN:"
        notes_content << "• Fecha de inicio: #{params[:start_date] || params[:rental_date] || params[:service_date] || 'No especificada'}"
        notes_content << "• Duración: #{params[:duration] || params[:rental_days] || 'No especificada'}"
        notes_content << ""
      end
      notes_content << params[:notes] if params[:notes].present?
      full_notes = notes_content.join("\n")

      lead = Lead.create!(
        client: client,
        name: "Cotización Web - #{params[:type]}",
        email: client.email,
        phone: client.phone,
        source: 'landing_page',
        lead_type: params[:type],
        notes: full_notes,
        status: 'new',
        priority: 'NC',
        assigned_to_id: default_advisor.id
      )

      # 3. Crear la Cotización Web (con el carrito de compras)
      quotation = Quotation.create!(
        client_id: client.id,
        lead_id: lead.id,
        quotation_type: params[:type], # 'sale', 'rental', 'spare_parts', etc.
        status: 'pending',
        valid_until: Time.current + 15.days,
        subtotal: params[:subtotal] || 0,
        tax: params[:tax] || 0,
        total: params[:total] || 0,
        advisor_id: nil
      )

      # 4. Procesar los Items del Carrito o Producto Individual
      if params[:items].present? && params[:items].is_a?(Array)
        params[:items].each do |item|
          item_hash = item.respond_to?(:to_unsafe_h) ? item.to_unsafe_h.symbolize_keys : item.to_h.symbolize_keys
          QuotationItem.create!(
            quotation_id: quotation.id,
            product_id: item_hash[:product_id],
            item_type: item_hash[:item_type] || 'product',
            description: item_hash[:description] || 'Producto Web',
            quantity: item_hash[:quantity] || 1,
            unit_price: item_hash[:unit_price] || 0,
            total_price: item_hash[:total_price] || 0
          )
        end
      else
        target_prod_id = params[:product_id] || params[:machine_id] || params[:product]
        if target_prod_id.present?
          product = Product.find_by(id: target_prod_id) || Product.find_by(code: target_prod_id)
          QuotationItem.create!(
            quotation_id: quotation.id,
            product_id: product&.id,
            item_type: 'product',
            description: product&.name || params[:product_name] || params[:machine_name] || "Máquina seleccionada: #{target_prod_id}",
            quantity: 1,
            unit_price: product&.base_price || 0,
            total_price: product&.base_price || 0
          )
        end
      end

      render json: { 
        message: "Cotización recibida exitosamente",
        new_account_created: is_new_client,
        quotation_code: quotation.code,
        lead_code: lead.code
      }, status: :ok
    end
  rescue StandardError => e
    render json: { message: "Error al procesar la solicitud", error: e.message }, status: :unprocessable_entity
  end
end
