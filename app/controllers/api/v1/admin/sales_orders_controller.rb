class Api::V1::Admin::SalesOrdersController < ApplicationController
  def index
    sales_orders = SalesOrder.includes(:client, :advisor, :quotation).order(created_at: :desc)
    render json: { sales_orders: sales_orders.as_json(include: [:client, :advisor, :quotation]) }, status: :ok
  end

  def show
    sales_order = SalesOrder.includes(:client, :advisor, :quotation).find(params[:id])
    render json: sales_order.as_json(include: [:client, :advisor, :quotation]), status: :ok
  end

  def destroy
    sales_order = SalesOrder.find(params[:id])
    if sales_order.destroy
      render json: { message: 'Orden eliminada correctamente' }, status: :ok
    else
      render json: { errors: sales_order.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
