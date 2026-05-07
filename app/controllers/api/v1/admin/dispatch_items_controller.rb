# app/controllers/api/v1/admin/dispatch_items_controller.rb

module Api
  module V1
    module Admin
      class DispatchItemsController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_item, only: [:show, :update, :destroy]
        skip_before_action :verify_authenticity_token

        # GET /api/v1/admin/dispatch_items
        def index
          @items = DispatchItem.includes(:dispatch_order, :product).all
          render json: @items, status: :ok
        end

        # GET /api/v1/admin/dispatch_items/:id
        def show
          render json: @item.as_json(
            include: {
              product: { only: [:id, :name, :code] },
              dispatch_order: { only: [:id, :code, :status] }
            }
          ), status: :ok
        end

        # GET /api/v1/admin/dispatch_orders/:dispatch_order_id/items
        def index_by_order
          @items = DispatchItem.includes(:product)
                               .where(dispatch_order_id: params[:dispatch_order_id])
          render json: @items, status: :ok
        end

        # POST /api/v1/admin/dispatch_items
        def create
          @item = DispatchItem.new(item_params)

          if @item.save
            render json: @item, status: :created
          else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # POST /api/v1/admin/dispatch_orders/:dispatch_order_id/items/bulk_create
        def bulk_create
          @order = DispatchOrder.find(params[:dispatch_order_id])
          errors = []

          ActiveRecord::Base.transaction do
            items_params.each do |item|
              dispatch_item = @order.dispatch_items.new(
                product_id: item[:product_id],
                quantity: item[:quantity],
                checked: item[:checked] || false
              )
              errors << dispatch_item.errors.full_messages unless dispatch_item.save
            end
            raise ActiveRecord::Rollback if errors.any?
          end

          if errors.empty?
            render json: @order.dispatch_items, status: :created
          else
            render json: { errors: errors.flatten }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/dispatch_items/:id
        def update
          if @item.update(item_params)
            render json: @item, status: :ok
          else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/dispatch_items/:id/check
        def check
          if @item.update(checked: true)
            render json: @item, status: :ok
          else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/dispatch_items/:id/uncheck
        def uncheck
          if @item.update(checked: false)
            render json: @item, status: :ok
          else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/dispatch_items/:id
        def destroy
          @item.destroy
          head :no_content
        end

        private

        def set_item
          @item = DispatchItem.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Dispatch item not found' }, status: :not_found
        end

        def item_params
          params.require(:dispatch_item).permit(:quantity, :checked, :product_id, :dispatch_order_id)
        end

        def items_params
          params.require(:items).map do |item|
            item.permit(:product_id, :quantity, :checked)
          end
        end
      end
    end
  end
end