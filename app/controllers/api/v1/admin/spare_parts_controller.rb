module Api
  module V1
    module Admin
      class SparePartsController < ApplicationController
        skip_before_action :verify_authenticity_token, raise: false
        before_action :set_spare_part, only: [:show, :update, :destroy]

        def index
          spare_parts = SparePart.includes(:product, :spare_part_category)
          render json: spare_parts, include: [:product, :spare_part_category]
        end

        def show
          render json: @spare_part, include: [:product, :spare_part_category, :spare_part_specs, :spare_part_compatibilities]
        end

        def create
          ActiveRecord::Base.transaction do
            product = Product.new(product_params)
            product.product_type = 'spare_part'

            if product.save
              spare_part = product.build_spare_part(spare_part_params)
              spare_part.status = product.active ? 'active' : 'inactive'

              if spare_part.save
                render json: spare_part, include: [:product], status: :created
              else
                raise ActiveRecord::Rollback
                render json: { errors: spare_part.errors.full_messages }, status: :unprocessable_entity
              end
            else
              render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end

        def update
          ActiveRecord::Base.transaction do
            if @spare_part.product.update(product_params)
              if @spare_part.update(spare_part_params)
                render json: @spare_part, include: [:product]
              else
                render json: { errors: @spare_part.errors.full_messages }, status: :unprocessable_entity
              end
            else
              render json: { errors: @spare_part.product.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end

        def destroy
          product = @spare_part.product
          @spare_part.destroy
          product.destroy
          head :no_content
        end

        private

        def set_spare_part
          @spare_part = SparePart.find(params[:id])
        end

        def product_params
          params.require(:product).permit(:code, :name, :description, :base_price, :active)
        end

        def spare_part_params
          params.require(:spare_part).permit(:part_number, :manufacturer_brand, :stock, :min_stock, :sale_unit, :is_critical, :spare_part_category_id)
        end
      end
    end
  end
end