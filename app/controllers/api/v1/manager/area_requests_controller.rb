class Api::V1::Manager::AreaRequestsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    # Auto-backfill existing completed requests that don't have unit_price stored yet
    AreaRequest.where(status: 'completed', unit_price: nil).each do |ar|
      item = ar.quotation&.quotation_items&.first
      ar.update_columns(unit_price: item.unit_price, machine_ready: true) if item
    end

    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    # El Manager Comercial puede ver todas las solicitudes hechas por sus asesores.
    # En producción: current_user.roleable.advisors.pluck(:id)
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
        quotation_items: req.quotation.quotation_items.map { |i| { description: i.description, quantity: i.quantity } },
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

  def create
    current_user_id = params[:user_id] || 1 
    
    # Verificamos que la cotización exista
    quotation = Quotation.find(params[:area_request][:quotation_id])

    area_request = AreaRequest.new(area_request_params)
    area_request.created_by_id = current_user_id
    area_request.status = 'pending'

    ActiveRecord::Base.transaction do
      if area_request.save
        quotation.update!(status: 'pending_area_review')
        render json: { message: "Solicitud enviada al área de #{area_request.area}", area_request: area_request }, status: :ok
      else
        render json: { message: "Error al crear la solicitud", errors: area_request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def area_request_params
    params.require(:area_request).permit(:quotation_id, :area, :name, :description)
  end
end
