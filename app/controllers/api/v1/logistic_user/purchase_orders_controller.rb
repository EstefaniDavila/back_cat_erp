module Api
  module V1
    module LogisticUser
      class PurchaseOrdersController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token

        def index
          @purchase_orders = PurchaseOrder.includes(:supplier, :requested_by, :purchase_order_items)
                                          .all.order(created_at: :desc)
          render json: @purchase_orders, status: :ok
        end

        def create
          @purchase_order = PurchaseOrder.new(purchase_order_params)
          @purchase_order.status = 'draft'

          if @purchase_order.save
            render json: @purchase_order, status: :created
          else
            render json: { errors: @purchase_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def purchase_order_params
          params.require(:purchase_order).permit(
            :supplier_id, 
            :requested_by_id, 
            :expected_date, 
            :received_at, 
            :notes, 
            :status,
            purchase_order_items_attributes: [:id, :product_id, :quantity, :unit_cost, :_destroy]
          )
        end
      end
    end
  end
end