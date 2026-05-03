# app/controllers/api/v1/warehouse/products_controller.rb
module Api
  module V1
    module Warehouse
      class ProductsController < ApplicationController  # ← CAMBIA ESTA LÍNEA
        before_action :set_product, only: [:show, :update_stock, :update_price]
        
        # GET /api/v1/warehouse/products
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
        
        # GET /api/v1/warehouse/products/:id
        def show
          render json: @product.as_json(
            include: {
              vehicle: { only: [:id, :serial, :status, :location, :price_per_hour, :price_per_day] },
              spare_part: { include: [:spare_part_category, :stock_movements] },
              product_images: {}
            }
          )
        end
        
        # PATCH /api/v1/warehouse/products/:id/update_stock
        def update_stock
          if @product.spare_part.present?
            @product.spare_part.update(stock: params[:stock])
            render json: { 
              message: 'Stock actualizado correctamente', 
              stock: @product.spare_part.stock,
              product: @product.name
            }
          else
            render json: { error: 'Solo los repuestos tienen stock' }, 
                   status: :unprocessable_entity
          end
        end
        
        # PATCH /api/v1/warehouse/products/:id/update_price
        def update_price
          if @product.update(base_price: params[:base_price])
            render json: { 
              message: 'Precio actualizado correctamente', 
              base_price: @product.base_price.to_f 
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
          {
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
        end
      end
    end
  end
end