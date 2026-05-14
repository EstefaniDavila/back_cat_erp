# app/controllers/api/v1/admin/stock_movements_controller.rb
module Api
  module V1
    module Admin
      class StockMovementsController < ApplicationController

        def index
          movements = StockMovement
            .includes(:spare_part, :performed_by)
            .order(created_at: :desc)

          render json: movements
        end

        def show
          movement = StockMovement.find(params[:id])
          render json: movement
        end

        def by_spare_part
          spare_part = SparePart.find(params[:spare_part_id])

          movements = spare_part.stock_movements
            .includes(:performed_by)
            .order(created_at: :asc)

          render json: movements
        end

      end
    end
  end
end 