# app/controllers/api/v1/admin/product_images_controller.rb
module Api
  module V1
    module Admin
      class ProductImagesController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :set_product_image, only: [:show, :update, :destroy]

        def index
          @product_images = ProductImage.all
          render json: @product_images
        end

        def by_product
          @product_images = ProductImage.where(product_id: params[:product_id])
          render json: @product_images
        end

        def show
          render json: @product_image
        end

        def create
          @product_image = ProductImage.new(product_image_params)
          if @product_image.save
            render json: @product_image, status: :created
          else
            render json: { errors: @product_image.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @product_image.update(product_image_params)
            render json: @product_image
          else
            render json: { errors: @product_image.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @product_image.destroy
          head :no_content
        end

        private

        def set_product_image
          @product_image = ProductImage.find(params[:id])
        end

        def product_image_params
          params.require(:product_image).permit(:url, :product_id)
        end
      end
    end
  end
end