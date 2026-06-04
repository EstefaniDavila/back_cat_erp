class Api::V1::Admin::AccessRequestsController < ApplicationController
  include SearchHelper

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    requests = AccessRequest.includes(:created_by)

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      requests = requests.ransack(search_conditions).result
    end

    total_requests = requests.count

    if params[:sort].present?
      field, order = params[:sort].split("%")
      requests = requests.order("#{field} #{order}")
    else
      requests = requests.order(created_at: :desc)
    end

    page = params[:page] || 1
    page_size = params[:pageSize] || 10
    requests = requests.page(page).per(page_size)

    requests_data = requests.map do |req|
      {
        id: req.id,
        **req.attributes.symbolize_keys,
        creator_email: req.created_by&.email,
        creator_name: req.created_by&.full_name,
        creator_role: req.created_by&.roleable_type,
        created_at: req.created_at.strftime("%d/%m/%Y %H:%M"),
        updated_at: req.updated_at.strftime("%d/%m/%Y %H:%M")
      }
    end

    render json: {
      access_requests: requests_data,
      current_page: requests.current_page,
      total_pages: requests.total_pages,
      per_pages: requests.limit_value,
      total_requests: total_requests
    }, status: :ok
  end

  def show
    req = AccessRequest.find(params[:id])
    render json: {
      access_request: {
        id: req.id,
        **req.attributes.symbolize_keys,
        created_at: req.created_at.strftime("%d/%m/%Y %H:%M"),
      },
      status: :ok
    }
  end

  # Marcar como completado
  def complete
    req = AccessRequest.find(params[:id])
    if req.update(status: 'completed')
      render json: { message: "Solicitud marcada como completada", access_request: req }, status: :ok
    else
      render json: { message: "Error al actualizar", errors: req.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
