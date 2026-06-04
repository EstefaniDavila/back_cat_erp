class Api::V1::Manager::AccessRequestsController < ApplicationController
  include SearchHelper

  def index
    current_user_id = params[:user_id] || 1
    
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    # Manager solo ve sus propias peticiones
    requests = AccessRequest.where(created_by_id: current_user_id).includes(:created_by)

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
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

  def create
    current_user_id = params[:user_id] || 1 

    access_request = AccessRequest.new(access_request_params)
    access_request.created_by_id = current_user_id
    access_request.status = 'pending'

    if access_request.save
      render json: { message: "Solicitud enviada al Administrador", access_request: access_request }, status: :ok
    else
      render json: { message: "Error al crear la solicitud", errors: access_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def access_request_params
    params.require(:access_request).permit(:requested_role, :first_name, :last_name, :document_type, :document_number, :email, :phone)
  end
end
