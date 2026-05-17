class Api::V1::Advisor::QuotationsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    current_advisor_id = params[:advisor_id] || 1 

    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    # El asesor ve las cotizaciones que tiene asignadas
    quotations = Quotation.where(advisor_id: current_advisor_id).includes(:client, :quotation_items)

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
      {
        id: quo.id,
        **quo.attributes.symbolize_keys,
        client_name: quo.client.business_name,
        customer: quo.client.business_name,
        lead_description: quo.lead&.notes,
        has_completed_area_request: quo.area_requests.where(status: 'completed').exists?,
        pending_area_request: quo.area_requests.where(status: 'pending').exists?,
        items: quo.quotation_items.map { |item|
          {
            id: item.id,
            product_id: item.product_id,
            description: item.description,
            quantity: item.quantity,
            unit_price: item.unit_price.to_f,
            total_price: item.total_price.to_f,
            item_type: item.item_type
          }
        },
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
    quotation = Quotation.find(params[:id])
    
    render json: {
      quotation: {
        id: quotation.id,
        **quotation.attributes.symbolize_keys,
        client_name: quotation.client.business_name,
        lead_description: quotation.lead&.notes,
        has_completed_area_request: quotation.area_requests.where(status: 'completed').exists?,
        pending_area_request: quotation.area_requests.where(status: 'pending').exists?,
        items: quotation.quotation_items,
        created_at: quotation.created_at.strftime("%d/%m/%Y %H:%M"),
      },
      status: :ok
    }
  end

  def create
    current_advisor_id = params[:advisor_id] || 1 
    quotation = Quotation.new(quotation_params)
    quotation.advisor_id = current_advisor_id
    quotation.status = 'draft' # El asesor siempre la crea como borrador

    if quotation.save
      render json: { message: "Cotización creada como borrador", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al crear", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    quotation = Quotation.find(params[:id])

    if quotation.update(quotation_params)
      render json: { message: "Cotización actualizada", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al actualizar", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # El asesor envía la cotización al cliente para su revisión
  def send_to_client
    quotation = Quotation.find(params[:id])

    # Verificar que el área ya completó la revisión (si es alquiler/mantenimiento)
    if (quotation.quotation_type == 'rental' || quotation.quotation_type == 'maintenance') &&
       !quotation.area_requests.where(status: 'completed').exists?
      render json: { message: "El área especializada aún no ha completado la revisión de esta cotización." }, status: :unprocessable_entity
      return
    end

    if quotation.update(status: 'sent')
      render json: { message: "Cotización enviada al cliente exitosamente", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al enviar al cliente", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # El asesor envía a revisión del manager (después que el cliente aprobó o lo tiene enviado)
  def send_for_approval
    quotation = Quotation.find(params[:id])

    # Solo bloquear si está en borrador — debe estar al menos enviada al cliente
    if quotation.status == 'draft'
      return render json: {
        message: "⚠️ La cotización aún es un borrador. Primero envíala al cliente con 'Enviar al Cliente'."
      }, status: :unprocessable_entity
    end

    if (quotation.quotation_type == 'rental' || quotation.quotation_type == 'maintenance') &&
       !quotation.area_requests.where(status: 'completed').exists?
      render json: { message: "Esta cotización debe ser revisada y completada primero por el área especializada de Alquiler/Mantenimiento." }, status: :unprocessable_entity
      return
    end

    if quotation.update(status: 'pending_approval')
      render json: { message: "Enviado a revisión del Gerente", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al enviar", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/advisor/quotations/:id/reset_to_sent
  # Reenviar al cliente si la cotización se adelantó sin aprobación del cliente
  def reset_to_sent
    quotation = Quotation.find(params[:id])

    if quotation.update(status: 'sent')
      render json: { message: "✅ Cotización enviada al cliente nuevamente. Ahora el cliente puede aprobarla o rechazarla.", quotation: quotation }, status: :ok
    else
      render json: { message: "Error al reenviar", errors: quotation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def quotation_params
    params.require(:quotation).permit(:quotation_type, :subtotal, :tax, :total, :valid_until, :client_id, :lead_id, :status)
  end
end
