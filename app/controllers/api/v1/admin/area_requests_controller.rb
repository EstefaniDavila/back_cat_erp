class Api::V1::Admin::AreaRequestsController < ApplicationController
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
    
    requests = AreaRequest.includes(:quotation, :reviewed_by, :created_by)

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
        quotation_code: req.quotation.code,
        quotation_items: req.quotation.quotation_items.map { |i| { description: i.description, quantity: i.quantity } },
        creator_email: req.created_by&.email,
        creator_role: req.created_by&.roleable_type,
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
    
    quotation = Quotation.find(params[:area_request][:quotation_id])

    area_request = AreaRequest.new(area_request_params)
    area_request.created_by_id = current_user_id
    area_request.status = 'pending'

    if area_request.save
      render json: { message: "Solicitud enviada al área de #{area_request.area}", area_request: area_request }, status: :ok
    else
      render json: { message: "Error al crear la solicitud", errors: area_request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Función para que Logística/Operaciones (o el Admin) respondan a la solicitud
  def reply
    current_user_id = params[:user_id] || 1 
    area_request = AreaRequest.find(params[:id])

    notes_text = params[:area_request][:notes]
    machine_status = params[:area_request][:machine_ready] == 'true' || params[:area_request][:machine_ready] == true ? "MÁQUINA LISTA/DISPONIBLE" : "MÁQUINA NO DISPONIBLE"
    est_days = params[:area_request][:estimated_days]
    s_date = params[:area_request][:start_date]
    pickup = params[:area_request][:pickup_details]
    rate_type = params[:area_request][:rental_rate_type]
    
    extra_details = ""
    extra_details += "\n• Tarifa: Por #{rate_type}" if rate_type.present? && rate_type != 'Global'
    extra_details += "\n• Tarifa: Global/Fija" if rate_type == 'Global'
    extra_details += "\n• Días Estimados: #{est_days}" if est_days.present?
    extra_details += "\n• Fecha de Inicio: #{s_date}" if s_date.present?
    extra_details += "\n• Logística/Recojo: #{pickup}" if pickup.present?
    
    full_reply_notes = "⚙️ REVISIÓN DEL ÁREA (#{area_request.area}):\n• Estado: #{machine_status}#{extra_details}\n• Observaciones: #{notes_text}"

    ActiveRecord::Base.transaction do
      unit_price_val = params[:area_request][:unit_price].present? ? params[:area_request][:unit_price].to_f : nil
      area_request.update!(
        notes: full_reply_notes, 
        status: 'completed', 
        machine_ready: params[:area_request][:machine_ready] == 'true' || params[:area_request][:machine_ready] == true,
        unit_price: unit_price_val,
        reviewed_by_id: current_user_id,
        reviewed_at: Time.current
      )

      # Actualizar el primer ítem de la cotización y los totales si pasaron un precio
      if params[:area_request][:unit_price].present?
        u_price = params[:area_request][:unit_price].to_f
        quo = area_request.quotation
        if quo
          first_item = quo.quotation_items.first
          if first_item
            first_item.update!(
              unit_price: u_price,
              total_price: u_price * first_item.quantity
            )
          end
          # Recalcular totales de la cotización
          subtotal = quo.quotation_items.sum(:total_price)
          tax = subtotal * 0.18
          total = subtotal + tax
          quo.update!(
            subtotal: subtotal,
            tax: tax,
            total: total
          )
        end
      end
    end

    render json: { message: "Respuesta enviada al Asesor", area_request: area_request }, status: :ok
  rescue => e
    render json: { message: "Error al responder", errors: [e.message] }, status: :unprocessable_entity
  end

  private

  def area_request_params
    params.require(:area_request).permit(:quotation_id, :area, :name, :description)
  end
end
