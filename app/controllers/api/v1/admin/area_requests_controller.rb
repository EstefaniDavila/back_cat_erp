class Api::V1::Admin::AreaRequestsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    requests = AreaRequest.includes(:quotation, :reviewed_by, :created_by)

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
        quotation_code: req.quotation.code,
        creator_email: req.created_by&.email,
        reviewer_email: req.reviewed_by&.email,
        created_at: req.created_at.strftime("%d/%m/%Y %H:%M"),
        updated_at: req.updated_at.strftime("%d/%m/%Y %H:%M")
      }
    end

    render json: {
      area_requests: requests_data,
      current_page: requests.current_page,
      total_pages: requests.total_pages,
      per_pages: requests.limit_value,
      total_requests: total_requests
    }, status: :ok
  end

  def show
    req = AreaRequest.find(params[:id])
    render json: {
      area_request: {
        id: req.id,
        **req.attributes.symbolize_keys,
        quotation: req.quotation.attributes.symbolize_keys,
        created_at: req.created_at.strftime("%d/%m/%Y %H:%M"),
      },
      status: :ok
    }
  end

  # Función para que Logística/Operaciones (o el Admin) respondan a la solicitud
  def reply
    current_user_id = params[:user_id] || 1 
    area_request = AreaRequest.find(params[:id])

    if area_request.update(
        notes: params[:area_request][:notes], 
        status: 'completed', 
        reviewed_by_id: current_user_id,
        reviewed_at: Time.current
      )
      render json: { message: "Respuesta enviada al Asesor", area_request: area_request }, status: :ok
    else
      render json: { message: "Error al responder", errors: area_request.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
