class Api::V1::Manager::QuotationsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    quotations = Quotation.includes(:client, :advisor)

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
        advisor_name: "#{quo.advisor.first_name} #{quo.advisor.last_name}",
        created_at: quo.created_at.strftime("%d/%m/%Y %H:%M"),
        updated_at: quo.updated_at.strftime("%d/%m/%Y %H:%M")
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
    
    render json: {
      quotation: {
        id: quotation.id,
        **quotation.attributes.symbolize_keys,
        client_name: quotation.client.business_name,
        advisor_name: "#{quotation.advisor.first_name} #{quotation.advisor.last_name}",
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
