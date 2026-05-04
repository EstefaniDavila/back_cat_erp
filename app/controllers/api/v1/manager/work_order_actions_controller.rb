class Api::V1::Manager::WorkOrderActionsController < ApplicationController
  include SearchHelper
  skip_before_action :verify_authenticity_token

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    work_order_actions = WorkOrderAction.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      work_order_actions = work_order_actions.ransack(search_conditions).result
    end
    total_records = work_order_actions.count
    if params[:sort].present?
      field, order = paramos[:sort].split('%')
      work_order_actions = work_order_actions.order(field => order)
    else
      work_order_actions = work_order_actions.order(created_at: :desc)
    end
    work_order_actions = work_order_actions.page(params[:page]).per(params[:per_page])

    render json: {
      work_order_actions: work_order_actions.as_json(),
      current_page: work_order_actions.current_page,
      total_pages: work_order_actions.total_pages,
      per_page: work_order_actions.limit_value,
      total_work_order_actions: total_records,
    }, status: :ok
  end

  def create
    work_order_action = WorkOrderAction.new(work_order_action_params)
    if work_order_action.save
      render json: { message: "Acción de orden de trabajo registrada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al registrar la acción de orden de trabajo", errors: work_order_action.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    work_order_action = WorkOrderAction.find(params[:id])
    if work_order_action.update(work_order_action_params)
      render json: { message: "Acción de orden de trabajo actualizada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al actualizar la acción de orden de trabajo", errors: work_order_action.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    work_order_action = WorkOrderAction.find(params[:id])
    if work_order_action.destroy
      render json: { message: "Acción de orden de trabajo eliminada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al eliminar la acción de orden de trabajo", errors: work_order_action.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def work_order_action_params
    params.require(:work_order_action).permit(:action, :description, :evidence, :performed_by_id, :work_order_id)
  end

end