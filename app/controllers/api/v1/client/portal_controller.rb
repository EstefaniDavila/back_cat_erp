class Api::V1::Client::PortalController < ApplicationController
  include SearchHelper
  
  # before_action :authenticate_and_set_user 
  # Aquí validaremos en el futuro que el current_user.roleable_type == 'Client'

  # GET /api/v1/client/portal/quotations
  def quotations
    current_client_id = params[:client_id] || 1 # En el futuro será current_user.roleable_id

    quotations = Quotation.where(client_id: current_client_id)
                          .where.not(status: ['draft', 'pending_area_review', 'pending_approval'])
                          .includes(:quotation_items)
                          .order(created_at: :desc)
    
    render json: {
      quotations: quotations.map do |quo|
        {
          id: quo.id,
          **quo.attributes.symbolize_keys,
          items: quo.quotation_items,
          created_at: quo.created_at.strftime("%d/%m/%Y %H:%M")
        }
      end
    }, status: :ok
  end

  # GET /api/v1/client/portal/maintenances
  def maintenances
    current_client_id = params[:client_id] || 1

    maintenances = Maintenance.where(client_id: current_client_id)
                              .includes(:work_orders)
                              .order(created_at: :desc)

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
    current_client_id = params[:client_id] || 1

    sales_orders = SalesOrder.where(client_id: current_client_id).order(created_at: :desc)
    rentals = Rental.where(client_id: current_client_id).order(created_at: :desc)

    render json: {
      sales_orders: sales_orders,
      rentals: rentals
    }, status: :ok
  end
end
