class Api::V1::Manager::QuotationsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    quotations = Quotation.includes(:client, :advisor, :quotation_items)

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
      quotations = quotations.ransack(search_conditions).result
    end

    total_quotations = quotations.count

    if params[:sort].present?
      field, order = params[:sort].split("%")
      quotations = quotations.order("#{field} #{order}")
    else
      quotations = quotations.order(created_at: :desc)
    end

    page = params[:page] || 1
    page_size = params[:pageSize] || 10
    quotations = quotations.page(page).per(page_size)

    quotations_data = quotations.map do |quo|
      advisor_name = quo.advisor ? "#{quo.advisor.first_name} #{quo.advisor.last_name}" : 'Sin asignar'
      {
        id: quo.id,
        **quo.attributes.symbolize_keys,
        client_name: quo.client&.business_name || quo.client&.contact_name || 'Sin cliente',
        customer: quo.client&.business_name || quo.client&.contact_name || 'Sin cliente',
        advisor: advisor_name,
        advisor_name: advisor_name,
        items: quo.quotation_items.map { |i| { id: i.id, description: i.description, quantity: i.quantity, unit_price: i.unit_price, total_price: i.total_price, item_type: i.item_type } },
        created_at: quo.created_at.strftime("%d/%m/%Y %H:%M"),
        updated_at: quo.updated_at.strftime("%d/%m/%Y %H:%M"),
        date: quo.created_at.strftime("%d/%m/%Y")
      }
    end

    render json: {
      quotations: quotations_data,
      current_page: quotations.current_page,
      total_pages: quotations.total_pages,
      per_pages: quotations.limit_value,
      total_quotations: total_quotations
    }, status: :ok
  end

  def show
    quotation = Quotation.find_by!(id: params[:id])
    
    advisor_name = if quotation.advisor.nil? || quotation.advisor.email == "sistema@erpcat.com"
                     "Sin asignar"
                   else
                     "#{quotation.advisor.first_name} #{quotation.advisor.last_name}"
                   end

    render json: {
      quotation: {
        id: quotation.id,
        **quotation.attributes.symbolize_keys,
        client_name: quotation.client.business_name,
        advisor_name: advisor_name,
        items: quotation.quotation_items,
        created_at: quotation.created_at.strftime("%d/%m/%Y %H:%M"),
      },
      status: :ok
    }
  end

  def approve
    quotation = Quotation.find(params[:id])

    if quotation.update(status: 'approved_internally', approved_at: Time.current)
      render json: { message: "Cotización aprobada. El asesor ya puede enviarla al cliente.", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al aprobar", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Rechazar cotización internamente
  def reject
    quotation = Quotation.find(params[:id])

    if quotation.update(status: 'rejected', rejected_at: Time.current)
      render json: { message: "Cotización rechazada. El asesor debe corregirla.", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al rechazar", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def client_accept
    quotation = Quotation.find(params[:id])

    if quotation.accept_and_generate_order!
      render json: { message: "Cotización aceptada por cliente. Se ha generado la orden automáticamente.", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al procesar la aceptación del cliente o la cotización ya estaba aceptada." }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/manager/quotations/:id/final_approve
  # El gerente aprueba con el visto bueno del cliente → se crea la orden operativa
  def final_approve
    quo = Quotation.find(params[:id])

    actionable_statuses = %w[client_approved pending_approval approved_internally sent]
    unless actionable_statuses.include?(quo.status)
      return render json: { message: "Esta cotización no está lista para aprobación final (estado actual: #{quo.status})" }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      quo.update!(status: 'approved', approved_at: Time.current)

      order_info = case quo.quotation_type
      when 'sale', 'spare_parts', 'contact'
        # → Logística (Orden de Venta / Despacho)
        order = SalesOrder.create!(
          code:         "ORD-#{SecureRandom.hex(3).upcase}",
          status:       'pending_dispatch',
          total:        quo.total,
          notes:        "Orden generada tras aprobación final del Gerente. Tipo: #{quo.quotation_type}.",
          quotation_id: quo.id,
          client_id:    quo.client_id,
          advisor_id:   quo.advisor_id
        )
        { model: 'SalesOrder', code: order.code, area: 'logistics', area_label: 'Logística', record: order }

      when 'rental'
        # → Operaciones (Alquiler)
        # vehicle_id se asigna en Logística/Operaciones cuando procesan la orden de despacho
        rental = Rental.create!(
          code:         "RNT-#{SecureRandom.hex(3).upcase}",
          status:       'pending',
          total:        quo.total,
          notes:        "Alquiler generado tras aprobación final del Gerente. Vehículo/equipo por asignar en Logística.",
          quotation_id: quo.id,
          client_id:    quo.client_id
        )
        { model: 'Rental', code: rental.code, area: 'operations', area_label: 'Operaciones', record: rental }

      when 'maintenance'
        # → Operaciones (Mantenimiento)
        maint = Maintenance.create!(
          code:             "MNT-#{SecureRandom.hex(3).upcase}",
          status:           'pending',
          maintenance_type: 'corrective',
          priority:         'normal',
          description:      quo.lead&.notes || "Mantenimiento solicitado por el cliente.",
          requested_at:     Time.current,
          client_id:        quo.client_id,
          quotation_id:     quo.id
        )
        { model: 'Maintenance', code: maint.code, area: 'operations', area_label: 'Operaciones', record: maint }

      else
        order = SalesOrder.create!(
          code:         "ORD-#{SecureRandom.hex(3).upcase}",
          status:       'pending_dispatch',
          total:        quo.total,
          notes:        "Orden generada (tipo: #{quo.quotation_type}).",
          quotation_id: quo.id,
          client_id:    quo.client_id,
          advisor_id:   quo.advisor_id
        )
        { model: 'SalesOrder', code: order.code, area: 'logistics', area_label: 'Logística', record: order }
      end

      # Determinar nombre y descripción de la solicitud de área según el tipo
      area_request_name = case quo.quotation_type
      when 'rental'
        "Preparar Alquiler - #{quo.client&.business_name || quo.client&.contact_name} [#{order_info[:code]}]"
      when 'maintenance'
        "Ejecutar Mantenimiento - #{quo.client&.business_name || quo.client&.contact_name} [#{order_info[:code]}]"
      else
        "Despacho de Orden - #{quo.client&.business_name || quo.client&.contact_name} [#{order_info[:code]}]"
      end

      area_request_description = [
        "Solicitud generada automáticamente al aprobar definitivamente la cotización #{quo.code}.",
        "Cliente: #{quo.client&.business_name || quo.client&.contact_name}",
        "Tipo de operación: #{quo.quotation_type&.upcase}",
        "Monto total: S/ #{quo.total&.to_f&.round(2)}",
        quo.lead&.notes.present? ? "\nDetalles del cliente:\n#{quo.lead.notes}" : nil
      ].compact.join("\n")

      # Crear el AreaRequest para la respectiva área
      AreaRequest.create!(
        area:           order_info[:area_label] || order_info[:area],
        name:           area_request_name,
        description:    area_request_description,
        status:         'pending',
        quotation_id:   quo.id,
        created_by_id:  quo.advisor&.user&.id || current_user&.id   # Referencia correcta al ID del User
      )

      render json: {
        message: "Cotización aprobada definitivamente. #{order_info[:model]} #{order_info[:code]} creado y solicitud enviada a #{order_info[:area_label] || order_info[:area]}.",
        quotation: quo,
        generated_order: { type: order_info[:model], code: order_info[:code], area: order_info[:area_label] || order_info[:area] }
      }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: "Error al crear la orden", errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    quotation = Quotation.find(params[:id])

    if quotation.update(quotation_params)
      render json: { message: "Cotización actualizada", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al actualizar", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def quotation_params
    params.require(:quotation).permit(:quotation_type, :status, :subtotal, :tax, :total, :valid_until, :client_id, :advisor_id)
  end
end
