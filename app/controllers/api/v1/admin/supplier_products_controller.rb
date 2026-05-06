module Api
  module V1
    module Admin
      class SupplierProductsController < ApplicationController
        protect_from_forgery with: :null_session, if: -> { request.format.json? }
        before_action :set_supplier_product, only: [:show, :update, :destroy]

        # GET /api/v1/admin/supplier_products
        def index
          @supplier_products = SupplierProduct.includes(:supplier, :product).all
          render json: @supplier_products, status: :ok
        end

        # GET /api/v1/admin/supplier_products/select
        def index_select
          @supplier_products = SupplierProduct.select(:id, :supplier_code, :unit_cost, :lead_time_days, :supplier_id, :product_id)
          render json: @supplier_products, status: :ok
        end

        # GET /api/v1/admin/supplier_products/:id
        def show
          render json: @supplier_product, status: :ok
        end

        # GET /api/v1/admin/suppliers/:supplier_id/supplier_products
        def index_by_supplier
          @supplier_products = SupplierProduct.includes(:product).where(supplier_id: params[:supplier_id])
          render json: @supplier_products, status: :ok
        end

        # GET /api/v1/admin/products/:product_id/supplier_products
        def index_by_product
          @supplier_products = SupplierProduct.includes(:supplier).where(product_id: params[:product_id])
          render json: @supplier_products, status: :ok
        end

        # POST /api/v1/admin/supplier_products
        def create
          @supplier_product = SupplierProduct.new(supplier_product_params)

          if @supplier_product.save
            render json: @supplier_product, status: :created
          else
            render json: { errors: @supplier_product.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/supplier_products/:id
        def update
          if @supplier_product.update(supplier_product_params)
            render json: @supplier_product, status: :ok
          else
            render json: { errors: @supplier_product.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/supplier_products/:id
        def destroy
          @supplier_product.destroy
          head :no_content
        end

        private

        def set_supplier_product
          @supplier_product = SupplierProduct.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Supplier product not found' }, status: :not_found
        end

        def supplier_product_params
          params.require(:supplier_product).permit(:supplier_code, :unit_cost, :lead_time_days, :supplier_id, :product_id)
        end
      end
    end
  end
end