# app/controllers/api/v1/warehouse/products_controller.rb
module Api
  module V1
    module Warehouse
      class ProductsController < ApplicationController
        before_action :set_product, only: [:update_status]
        
        # GET /api/v1/warehouse/products
        def index
          @products = filtered_products
                      .includes(:vehicle, :spare_part)
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
        
        # PATCH /api/v1/warehouse/products/:id/update_status
        def update_status
          if @product.update(active: params[:active])
            render json: { 
              message: 'Estado actualizado correctamente',
              active: @product.active
            }
          else
            render json: { errors: @product.errors.full_messages }, 
                   status: :unprocessable_entity
          end
        end
        
        private
        
        def set_product
          @product = Product.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Producto no encontrado' }, status: :not_found
        end
        
        def filtered_products
          products = Product.all
          
          products = products.where(product_type: params[:type]) if params[:type].present?
          products = products.where(active: true) if params[:active] == 'true'
          products = products.where(active: false) if params[:inactive] == 'true'
          products = products.where(code: params[:code]) if params[:code].present?
          products = products.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
          
          if params[:min_price].present?
            products = products.where('base_price >= ?', params[:min_price])
          end
          
          if params[:max_price].present?
            products = products.where('base_price <= ?', params[:max_price])
          end
          
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
            created_at: product.created_at,
            updated_at: product.updated_at
            
          }

          if product.vehicle?
            json[:vehicle] = {
              serial: product.vehicle&.serial,
              manufacture_year: product.vehicle&.manufacture_year,
              hours_used: product.vehicle&.hours_used,
              status: product.vehicle&.status,
              location: product.vehicle&.location,
              vehicle_model: product.vehicle&.vehicle_model&.model,
              vehicle_brand: product.vehicle&.vehicle_model&.brand
            }
          elsif product.spare_part?
            json[:spare_part] = {
              part_number: product.spare_part&.part_number,
              manufacturer_brand: product.spare_part&.manufacturer_brand,
              stock: product.spare_part&.stock || 0,
              min_stock: product.spare_part&.min_stock || 5,
              category: product.spare_part&.spare_part_category&.name
            }
          end

          json
        end
      end
    end
  end
end