class Api::V1::Admin::InformationRequestsController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, raise: false
  include SearchHelper

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    
    requests = InformationRequest.includes(:client, :advisor)

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
      requests = requests.ransack(search_conditions).result
    end

    total = requests.count

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
        client_name: req.client ? req.client.business_name : req.name,
        client_phone: req.client ? req.client.phone : req.phone,
        client_id: req.client_id,
        subject: req.subject,
        message: req.message,
        status: req.status,
        response: req.response,
        advisor_name: req.advisor&.full_name,
        created_at: req.created_at.strftime("%d/%m/%Y %H:%M"),
        document_url: req.document.attached? ? url_for(req.document) : nil
      }
    end

    render json: {
      information_requests: requests_data,
      current_page: requests.current_page,
      total_pages: requests.total_pages,
      per_pages: requests.limit_value,
      total_requests: total
    }, status: :ok
  end

  def respond
    req = InformationRequest.find(params[:id])
    advisor_id = params[:advisor_id]
    
    req.document.attach(params[:document]) if params[:document].present?

    if req.update(response: params[:response], status: 'resolved', advisor_id: advisor_id)
      render json: { message: "Respuesta guardada y solicitud resuelta", information_request: req }, status: :ok
    else
      render json: { message: "Error al guardar respuesta", errors: req.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
