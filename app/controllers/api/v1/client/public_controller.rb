class Api::V1::Client::PublicController < ApplicationController
  # Este controlador NO debe tener `before_action :authenticate_user`
  # porque es público para la Landing Page
  
  def request_quote
    ActiveRecord::Base.transaction do
      # 1. Buscar si el cliente ya existe por email o documento
      client = Client.find_by(email: params[:email]) || Client.find_by(document_number: params[:document_number])
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
        a.document_number = "00000000"
      end
      default_advisor.save(validate: false) if default_advisor.new_record?

      lead = Lead.create!(
        client: client,
        name: "Cotización Web - #{params[:type]}",
        email: client.email,
        phone: client.phone,
        source: 'landing_page',
        lead_type: params[:type],
        notes: params[:notes],
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
        advisor_id: default_advisor.id
      )

      # 4. Procesar los Items del Carrito
      if params[:items].present? && params[:items].is_a?(Array)
        params[:items].each do |item|
          QuotationItem.create!(
            quotation_id: quotation.id,
            product_id: item[:product_id],
            item_type: item[:item_type] || 'product',
            description: item[:description] || 'Producto Web',
            quantity: item[:quantity] || 1,
            unit_price: item[:unit_price] || 0,
            total_price: item[:total_price] || 0
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
