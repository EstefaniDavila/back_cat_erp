module Api
  module V1
    module LogisticUser
      class ProductsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :set_product, only: [:show]

        # GET /api/v1/logistic_user/products
        def index
          @products = filtered_products
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(params[:per_page] || 20)
          
          render json: {
            data: @products.map { |p| product_json(p) },
            meta: {
              current_page: @products.current_page,
              total_pages: @products.total_pages,
              total_count: @products.total_count
            }
          }
        end

        # GET /api/v1/logistic_user/products/:id
        def show
          render json: product_json(@product)
        end

        # GET /api/v1/logistic_user/products/search
        def search
          @products = Product.active
                        .where('code ILIKE :q OR name ILIKE :q', q: "%#{params[:q]}%")
                        .limit(10)
          
          render json: @products.map { |p| { id: p.id, code: p.code, name: p.name, price: p.base_price.to_f } }
        end

        private

        def set_product
          @product = Product.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Producto no encontrado' }, status: :not_found
        end

        def filtered_products
          products = Product.includes(
            vehicle: { vehicle_model: :vehicle_type },
            spare_part: :spare_part_category
          )

          if params[:vehicle_type_id].present?
            products = products
              .joins(vehicle: :vehicle_model)
              .where(vehicle_models: { vehicle_type_id: params[:vehicle_type_id] })
          end

          products = products.where(product_type: params[:type]) if params[:type].present?
          products = products.where(active: true) if params[:active] == 'true'
          products = products.where(code: params[:code]) if params[:code].present?
          products = products.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
          
          products
        end

        def product_json(product)
          json = {
            id: product.id,
            code: product.code,
            name: product.name,
            product_type: product.product_type,
            description: product.description,
            base_price: product.base_price.to_f,
            active: product.active,
            created_at: product.created_at
          }

          if product.vehicle?
            json[:vehicle] = {
              serial: product.vehicle&.serial,
              manufacture_year: product.vehicle&.manufacture_year,
              status: product.vehicle&.status,
              vehicle_model: product.vehicle&.vehicle_model&.model,
              vehicle_brand: product.vehicle&.vehicle_model&.brand,
              vehicle_type: product.vehicle&.vehicle_model&.vehicle_type&.name
            }
          elsif product.spare_part?
            json[:spare_part] = {
              part_number: product.spare_part&.part_number,
              manufacturer_brand: product.spare_part&.manufacturer_brand,
              stock: product.spare_part&.stock || 0,
              category: product.spare_part&.spare_part_category&.name
            }
          end
          json
        end
      end
    end
  end
end