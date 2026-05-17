# app/controllers/api/v1/warehouse/purchase_orders_controller.rb
module Api
  module V1
    module Warehouse
      class PurchaseOrdersController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_purchase_order, only: [:show, :receive, :cancel]

        skip_before_action :verify_authenticity_token

        # GET /api/v1/warehouse/purchase_orders

        def index
          @purchase_orders = PurchaseOrder.includes(:supplier, :purchase_order_items)
                                          .order(created_at: :desc)
          render json: @purchase_orders, status: :ok
        end

        # GET /api/v1/warehouse/purchase_orders/select

        def index_select
          @purchase_orders = PurchaseOrder.select(:id, :code, :status, :total, :supplier_id)
                                          .order(created_at: :desc)
          render json: @purchase_orders, status: :ok
        end

        # GET /api/v1/warehouse/purchase_orders/:id
        def show
          render json: @purchase_order.as_json(
            include: {
              supplier: { only: [:id, :business_name, :code] },
              purchase_order_items: {
                include: { product: { only: [:id, :name, :code] } }
              }
            }
          ), status: :ok
        end

        # PUT /api/v1/warehouse/purchase_orders/:id/receive
        def receive
          if @purchase_order.receive!
            render json: { 
              message: 'Orden recibida correctamente',
              status: @purchase_order.status,
              received_at: @purchase_order.received_at
            }, status: :ok
          else
            render json: { errors: @purchase_order.errors.full_messages }, 
                   status: :unprocessable_entity
          end
        end

        # PUT /api/v1/warehouse/purchase_orders/:id/cancel
        def cancel
          if @purchase_order.update(status: 'cancelled')
            render json: { 
              message: 'Orden cancelada correctamente',
              status: @purchase_order.status
            }, status: :ok
          else
            render json: { errors: @purchase_order.errors.full_messages }, 
                   status: :unprocessable_entity
          end
        end

        private

        def set_purchase_order
          @purchase_order = PurchaseOrder.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Purchase order not found' }, status: :not_found
        end
      end
    end
  end
end