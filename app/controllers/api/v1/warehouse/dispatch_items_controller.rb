# app/controllers/api/v1/warehouse/dispatch_items_controller.rb
module Api
  module V1
    module Warehouse
      class DispatchItemsController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_item, only: [:show]
        skip_before_action :verify_authenticity_token

        # GET /api/v1/warehouse/dispatch_items
        def index
          @items = DispatchItem.includes(:dispatch_order, :product).all
          render json: @items, status: :ok
        end

        # GET /api/v1/warehouse/dispatch_items/:id
        def show
          render json: @item.as_json(include: { product: { only: [:id, :name, :code] } }), status: :ok
        end

        # GET /api/v1/warehouse/dispatch_orders/:dispatch_order_id/items
        def index_by_order
          @items = DispatchItem.includes(:product).where(dispatch_order_id: params[:dispatch_order_id])
          render json: @items, status: :ok
        end

        private

        def set_item
          @item = DispatchItem.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Item not found' }, status: :not_found
        end
      end
    end
  end
end