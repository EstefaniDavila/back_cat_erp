class Api::V1::Manager::WorkOrderPartsController < ApplicationController
  include SearchHelper
  skip_before_action :verify_authenticity_token

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    work_order_parts = WorkOrderPart.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      work_order_parts = work_order_parts.ransack(search_conditions).result
    end
    total_records = work_order_parts.count
    if params[:sort].present?
      field, order = paramos[:sort].split('%')
      work_order_parts = work_order_parts.order(field => order)
    else
      work_order_parts = work_order_parts.order(created_at: :desc)
    end
    work_order_parts = work_order_parts.page(params[:page]).per(params[:per_page])

    render json: {
      work_order_parts: work_order_parts.as_json(),
      current_page: work_order_parts.current_page,
      total_pages: work_order_parts.total_pages,
      per_page: work_order_parts.limit_value,
      total_work_order_parts: total_records,
    }, status: :ok
  end

  def create
    work_order_part = WorkOrderPart.new(work_order_part_params)
    if work_order_part.save
      render json: { message: "Pieza de orden de trabajo registrada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al registrar la pieza de orden de trabajo", errors: work_order_part.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    work_order_part = WorkOrderPart.find(params[:id])
    if work_order_part.update(work_order_part_params)
      render json: { message: "Pieza de orden de trabajo actualizada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al actualizar la pieza de orden de trabajo", errors: work_order_part.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    work_order_part = WorkOrderPart.find(params[:id])
    if work_order_part.destroy
      render json: { message: "Pieza de orden de trabajo eliminada con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al eliminar la pieza de orden de trabajo", errors: work_order_part.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def work_order_part_params
    params.require(:work_order_part).permit(:quantity, :unit_price, :work_order_id, :product_id)
  end

end