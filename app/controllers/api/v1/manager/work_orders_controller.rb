class Api::V1::Manager::WorkOrdersController < ApplicationController
  include SearchHelper
  protect_from_forgery with: :null_session

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
          },
          work_order_actions: {
            only: [:id, :action, :description, :evidence]
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
        include: {
          maintenance: {
            only: [
              :id,
              :code,
              :description,
              :maintenance_type,
              :priority,
              :scheduled_at,
              :quotation_id,
              :status
            ],
            include: {
              client: {
                only: [:id, :business_name]
              },
              enterprise_vehicle: {
                only: [:id, :serial, :manufacture_year, :hours_used],
                include: {
                  product: {
                    only: [:id, :name]
                  }
                }
              }
            }
          }
        }
      ),
      current_page: work_orders.current_page,
      total_pages: work_orders.total_pages,
      per_page: work_orders.limit_value,
      total_work_orders: total_records,
    }, status: :ok
  end

  def calendar_by_technician
    technician_id = params[:technician_id]
    work_orders = WorkOrder
                    .includes(:maintenance)
                    .where(assigned_to_id: technician_id)
    events = work_orders.map do |work_order|
      scheduled_date = work_order.scheduled_date
      colors =
      case work_order.status
      when "CLOSED"
        {
          backgroundColor: "#ef4444",
          borderColor: "#ef4444",
          textColor: "#ffffff"
        }
      when "OPEN"
        {
          backgroundColor: "#22c55e",
          borderColor: "#22c55e",
          textColor: "#ffffff"
        }
      when "IN_PROGRESS"
        {
          backgroundColor: "#eab308",
          borderColor: "#eab308",
          textColor: "#ffffff"
        }
      else
        {
          backgroundColor: "#3b82f6",
          borderColor: "#3b82f6",
          textColor: "#ffffff"
        }
      end
      {
        id: work_order.id,
        title: "#{scheduled_date.strftime('%H:%M')} - #{work_order.maintenance&.description}",
        start: scheduled_date,
        **colors,
        extendedProps: {
          status: work_order.status,
          maintenance_id: work_order.maintenance_id,
          work_order_type: work_order.work_order_type
        }
      }
    end
    render json: events, status: :ok
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

  def update_diagnosis
    work_order = WorkOrder.find(params[:id])
    if work_order.update(diagnosis_params)
      render json: {message: "Diagnóstico actualizado con éxito", work_order: work_order}, status: :ok
    else
      render json: {
        message: "Ocurrió un error al actualizar el diagnóstico", errors: work_order.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update_status
    work_order = WorkOrder.find(params[:id])
    if work_order.update(status_params)
      render json: {message: "Estado actualizado con éxito", work_order: work_order}, status: :ok
    else
      render json: {
        message: "Ocurrió un error al actualizar el estado", errors: work_order.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def work_order_params
    params.require(:work_order).permit(:diagnosis, :diagnosis_result, :work_order_type, :status, :scheduled_date, :closed_date, :maintenance_id, :assigned_to_id)
  end

  def diagnosis_params
    params.require(:work_order).permit(:diagnosis, :diagnosis_result, :status)
  end

  def status_params
    params.require(:work_order).permit(:status)
  end

end