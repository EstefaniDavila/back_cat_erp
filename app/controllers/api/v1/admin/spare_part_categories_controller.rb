module Api
  module V1
    module Admin
      class SparePartCategoriesController < ApplicationController
        before_action :set_category, only: [:show, :update, :destroy]

        def index
          categories = SparePartCategory.order(:name)
          render json: categories
        end

        def index_select
          categories = SparePartCategory.select(:id, :name).order(:name)
          render json: categories
        end

        def show
          render json: @category
        end

        def create
          category = SparePartCategory.new(category_params)
          if category.save
            render json: category, status: :created
          else
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @category.update(category_params)
            render json: @category
          else
            render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @category.destroy
          head :no_content
        end

        private

        def set_category
          @category = SparePartCategory.find(params[:id])
        end

        def category_params
          params.require(:spare_part_category).permit(:name, :description)
        end
      end
    end
  end
end