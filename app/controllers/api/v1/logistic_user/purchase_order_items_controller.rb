module Api
  module V1
    module LogisticUser
      class PurchaseOrderItemsController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_item, only: [:show, :update, :destroy]
        skip_before_action :verify_authenticity_token

        # GET /api/v1/LogisticUser/purchase_order_items
        def index
          @items = PurchaseOrderItem.includes(:purchase_order, :product).all
          render json: @items, status: :ok
        end

        # GET /api/v1/LogisticUser/purchase_order_items/:id
        def show
          render json: @item.as_json(include: { product: { only: [:id, :name, :code] } }), status: :ok
        end

        # GET /api/v1/LogisticUser/purchase_orders/:purchase_order_id/items
        def index_by_order
          @items = PurchaseOrderItem.includes(:product).where(purchase_order_id: params[:purchase_order_id])
          render json: @items, status: :ok
        end

        # POST /api/v1/LogisticUser/purchase_order_items
        def create
          @item = PurchaseOrderItem.new(item_params)

          if @item.save
            recalculate_order_total(@item.purchase_order)
            render json: @item, status: :created
          else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/LogisticUser/purchase_order_items/:id
        def update
          if @item.update(item_params)
            recalculate_order_total(@item.purchase_order)
            render json: @item, status: :ok
          else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/LogisticUser/purchase_order_items/:id
        def destroy
          order = @item.purchase_order
          @item.destroy
          recalculate_order_total(order)
          head :no_content
        end

        # POST /api/v1/LogisticUser/purchase_orders/:purchase_order_id/items/bulk_create
        def bulk_create
          @order = PurchaseOrder.find(params[:purchase_order_id])
          
          ActiveRecord::Base.transaction do
            items_params.each do |item|
              @order.purchase_order_items.create!(item.permit(:product_id, :quantity, :unit_cost))
            end
          end
          
          recalculate_order_total(@order)
          render json: @order.purchase_order_items, status: :created
        rescue => e
          render json: { errors: e.message }, status: :unprocessable_entity
        end

        private

        def set_item
          @item = PurchaseOrderItem.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Item not found' }, status: :not_found
        end

        def item_params
          params.require(:purchase_order_item).permit(:quantity, :unit_cost, :product_id, :purchase_order_id)
        end

        def items_params
          params.require(:items)
        end

        def recalculate_order_total(order)
          total = order.purchase_order_items.sum(:total_cost)
          order.update_column(:total, total)
        end
      end
    end
  end
end