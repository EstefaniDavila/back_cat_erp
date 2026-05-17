class Api::V1::Client::PortalController < ApplicationController
  include SearchHelper
  
  # before_action :authenticate_and_set_user 
  # Aquí validaremos en el futuro que el current_user.roleable_type == 'Client'

  # GET /api/v1/client/portal/quotations
  def quotations
    client_id_param = params[:client_id]
    current_client_id = (client_id_param.blank? || client_id_param == "undefined" || client_id_param == "1") ? nil : client_id_param

    # Solo cotizaciones que ya fueron enviadas al cliente o más avanzadas (no borradores)
    quotations = current_client_id ? Quotation.where(client_id: current_client_id).where.not(status: 'draft').includes(:quotation_items).order(created_at: :desc) : Quotation.none
    
    # Leads sin cotización, o cuya cotización aún es borrador (no ha sido enviada al cliente)
    leads_without_quotation = if current_client_id
      Lead.left_outer_joins(:quotations)
          .where(client_id: current_client_id)
          .where("quotations.id IS NULL OR quotations.status = ?", "draft")
          .distinct
          .order(created_at: :desc)
    else
      Lead.none
    end

    mapped_requests = []

    quotations.each do |quo|
      mapped_requests << {
        id: quo.id,
        lead_id: quo.lead_id,
        code: quo.code || (quo.lead&.code),
        quotation_type: quo.quotation_type || (quo.lead&.lead_type),
        status: quo.status,
        total: quo.total || 0.0,
        items: quo.quotation_items,
        created_at: quo.created_at.strftime("%d/%m/%Y %H:%M"),
        date: quo.created_at.strftime("%d/%m/%Y %H:%M") 
      }
    end

    # Mapear los leads sin cotización o con cotización borrador como "en_revision" o "pendiente"
    leads_without_quotation.each do |lead|
      # Si el lead ya tiene una cotización pero es draft, el cliente lo ve como "en_revision" (técnica)
      has_draft = lead.quotations.exists?(status: 'draft')
      status_to_show = has_draft ? 'en_revision' : ((lead.status == 'new' || lead.status == 'assigned') ? 'pendiente' : lead.status)
      
      mapped_requests << {
        id: lead.id, # Usamos el ID del lead para que React no falle
        lead_id: lead.id,
        code: lead.code,
        quotation_type: lead.lead_type,
        status: status_to_show,
        total: 0.0,
        items: [{ description: lead.notes || "Solicitud Inicial", quantity: 1, item_type: lead.lead_type }],
        created_at: lead.created_at.strftime("%d/%m/%Y %H:%M"),
        date: lead.created_at.strftime("%d/%m/%Y %H:%M")
      }
    end

    # Ordenar todo combinado por fecha descendente
    mapped_requests.sort_by! { |req| Time.strptime(req[:date], "%d/%m/%Y %H:%M") }.reverse!

    render json: {
      quotations: mapped_requests,
      debug_info: {
        current_client_id_received: current_client_id,
        total_leads_for_this_client: Lead.where(client_id: current_client_id).count,
        total_quotations_for_this_client: Quotation.where(client_id: current_client_id).count,
        all_leads_in_db: Lead.count,
        all_quotations_in_db: Quotation.count,
        all_leads_for_this_client: Lead.where(client_id: current_client_id).map { |l| { id: l.id, type: l.lead_type, code: l.code } },
        all_quotations_for_this_client: Quotation.where(client_id: current_client_id).map { |q| { id: q.id, type: q.quotation_type, code: q.code } }
      }
    }, status: :ok
  end

  # GET /api/v1/client/portal/maintenances
  def maintenances
    client_id_param = params[:client_id]
    current_client_id = (client_id_param.blank? || client_id_param == "undefined" || client_id_param == "1") ? nil : client_id_param

    maintenances = current_client_id ? Maintenance.where(client_id: current_client_id).includes(:work_orders).order(created_at: :desc) : Maintenance.none

    render json: {
      maintenances: maintenances.map do |maint|
        {
          id: maint.id,
          **maint.attributes.symbolize_keys,
          work_orders: maint.work_orders,
          created_at: maint.created_at.strftime("%d/%m/%Y %H:%M")
        }
      end
    }, status: :ok
  end

  # GET /api/v1/client/portal/orders
  def orders
    client_id_param = params[:client_id]
    current_client_id = (client_id_param.blank? || client_id_param == "undefined" || client_id_param == "1") ? nil : client_id_param

    sales_orders = current_client_id ? SalesOrder.where(client_id: current_client_id).order(created_at: :desc) : SalesOrder.none
    rentals = current_client_id ? Rental.where(client_id: current_client_id).order(created_at: :desc) : Rental.none

    render json: {
      sales_orders: sales_orders,
      rentals: rentals
    }, status: :ok
  end

  # PUT /api/v1/client/portal/quotations/:id/approve
  def approve_quotation
    quo = Quotation.find(params[:id])
    if quo.update(status: 'client_approved', approved_at: Time.current)
      render json: { message: "Cotización aprobada por el cliente. El asesor podrá enviarla al Gerente para aprobación final.", quotation: quo }, status: :ok
    else
      render json: { message: "Error al aprobar", errors: quo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/client/portal/quotations/:id/reject
  def reject_quotation
    quo = Quotation.find(params[:id])
    if quo.update(status: 'client_rejected')
      render json: { message: "Cotización rechazada", quotation: quo }, status: :ok
    else
      render json: { message: "Error al rechazar", errors: quo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/client/portal/quotations/:id/comments
  def add_comment
    quo = Quotation.find(params[:id])
    comment = quo.quotation_comments.build(comment: params[:comment], user_id: current_user&.id)
    if comment.save
      render json: { message: "Comentario agregado exitosamente", comment: comment }, status: :ok
    else
      render json: { message: "Error al agregar comentario", errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/client/portal/quotations/:id/pdf
  def quotation_pdf
    request.format = :pdf
    @quotation = Quotation.find_by(id: params[:id])
    if @quotation
      @client = @quotation.client
      @items = @quotation.quotation_items
      @doc_code = @quotation.code || @quotation.id
      @doc_type = @quotation.quotation_type || 'Venta'
      @notes = @quotation.lead&.notes
    else
      @lead = Lead.find_by(id: params[:id])
      return render json: { error: 'Documento no encontrado' }, status: :not_found unless @lead
      
      @client = @lead.client
      @items = [] # Leads nuevos no tienen ítems cotizados formalmente
      @doc_code = @lead.code || @lead.id
      @doc_type = @lead.lead_type || 'Solicitud'
      @notes = @lead.notes
    end
    
    render pdf: "Documento_#{@doc_code}",
           template: "api/v1/client/portal/quotation_pdf",
           layout: 'pdf',
           page_size: 'A4',
           encoding: 'UTF-8',
           margin: { top: 20, bottom: 20, left: 15, right: 15 }
  end
end
