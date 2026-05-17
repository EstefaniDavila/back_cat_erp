class Api::V1::Manager::WorkOrdersController < ApplicationController
  include SearchHelper
  skip_before_action :verify_authenticity_token

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    work_orders = WorkOrder.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      work_orders = work_orders.ransack(search_conditions).result
    end
    total_records = work_orders.count
    if params[:sort].present?
      field, order = paramos[:sort].split('%')
      work_orders = work_orders.order(field => order)
    else
      work_orders = work_orders.order(created_at: :desc)
    end
    work_orders = work_orders.page(params[:page]).per(params[:per_page])

    render json: {
      work_orders: work_orders.as_json(),
      current_page: work_orders.current_page,
      total_pages: work_orders.total_pages,
      per_page: work_orders.limit_value,
      total_work_orders: total_records,
    }, status: :ok
  end

  def index_by_maintenance
    maintenance_id = params[:maintenance_id]
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    work_orders = WorkOrder.where(maintenance_id: maintenance_id)

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      work_orders = work_orders.ransack(search_conditions).result
    end
    total_records = work_orders.count
    if params[:sort].present?
      field, order = params[:sort].split('%')
      work_orders = work_orders.order(field => order)
    else
      work_orders = work_orders.order(created_at: :desc)
    end
    work_orders = work_orders.page(params[:page]).per(params[:per_page])

    render json: {
      work_orders: work_orders.as_json(
        include: {
          assigned_to: {
            only: [:id, :full_name]
          }
        }
      ),
      current_page: work_orders.current_page,
      total_pages: work_orders.total_pages,
      per_page: work_orders.limit_value,
      total_work_orders: total_records,
    }, status: :ok
  end

  def index_by_technician
    technician_id = params[:technician_id]
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    work_orders = WorkOrder.where(assigned_to_id: technician_id)

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      work_orders = work_orders.ransack(search_conditions).result
    end
    total_records = work_orders.count
    if params[:sort].present?
      field, order = params[:sort].split('%')
      work_orders = work_orders.order(field => order)
    else
      work_orders = work_orders.order(created_at: :desc)
    end
    work_orders = work_orders.page(params[:page]).per(params[:per_page])

    render json: {
      work_orders: work_orders.as_json(
        include: [:maintenance]
      ),
      current_page: work_orders.current_page,
      total_pages: work_orders.total_pages,
      per_page: work_orders.limit_value,
      total_work_orders: total_records,
    }, status: :ok
  end

  def create
    work_order = WorkOrder.new(work_order_params)
    if work_order.save
      render json: { message: "Orden de trabajo registrada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al registrar la orden de trabajo", errors: work_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    work_order = WorkOrder.find(params[:id])
    if work_order.update(work_order_params)
      render json: { message: "Orden de trabajo actualizada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al actualizar la orden de trabajo", errors: work_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    work_order = WorkOrder.find(params[:id])
    if work_order.work_order_actions.empty? && work_order.work_order_parts.empty?
      if work_order.destroy
        render json: { message: "Orden de trabajo eliminada con éxito" }, status: :ok
      else
        render json: { message: "Ocurrió un error al eliminar la orden de trabajo", errors: work_order.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "La orden de trabajo tiene registros asociados", errors: work_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def work_order_params
    params.require(:work_order).permit(:diagnosis, :diagnosis_result, :work_order_type, :status, :scheduled_date, :closed_date, :maintenance_id, :assigned_to_id)
  end

end