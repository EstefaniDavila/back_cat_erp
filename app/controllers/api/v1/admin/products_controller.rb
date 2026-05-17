# app/controllers/api/v1/admin/products_controller.rb

module Api
  module V1
    module Admin
      class ProductsController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :set_product, only: [:show, :update, :destroy, :toggle_active]
        
        # GET /api/v1/admin/products
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
        
        # GET /api/v1/admin/products/:id
        def show
          render json: product_json(@product)
        end
        
        # POST /api/v1/admin/products
        def create
          @product = Product.new(product_params)
         

          if @product.save
            render json: product_json(@product), status: :ok
          else
            render json: {
          error: "No se pudo crear el producto",
                   messages: @product.errors.full_messages,
                    details: @product.spare_part&.errors&.full_messages
        }, status: :unprocessable_entity
          end
        end
        
        # PATCH/PUT /api/v1/admin/products/:id
        def update
          #@product.updated_by_id = current_user&.id
          
          if @product.update(product_params)
            render json: product_json(@product)
          else
            render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        # DELETE /api/v1/admin/products/:id
        def destroy
          if @product.quotation_items.exists? || 
             @product.work_order_parts.exists? || 
             @product.dispatch_items.exists? ||
             @product.purchase_order_items.exists?
            render json: { error: 'No se puede eliminar el producto porque tiene transacciones asociadas' }, 
                   status: :unprocessable_entity
          else
            @product.destroy
            head :no_content
          end
        end
        
        # PATCH /api/v1/admin/products/:id/toggle_active
        def toggle_active
          @product.toggle_active!
          render json: { active: @product.active, message: 'Estado actualizado' }
        end
        
        # GET /api/v1/admin/products/search
        def search
          @products = Product.active
                      .where('code ILIKE :q OR name ILIKE :q', q: "%#{params[:q]}%")
                      .limit(10)
          
          render json: @products.map { |p| { id: p.id, code: p.code, name: p.name, price: p.base_price.to_f } }
        end
        
        # GET /api/v1/admin/products/export_csv
        def export_csv
          @products = filtered_products.order(created_at: :desc)
          
          csv_data = CSV.generate(headers: true) do |csv|
            csv << ['ID', 'Código', 'Nombre', 'Tipo', 'Precio Base', 'Activo', 'Creado el']
            
            @products.each do |product|
              csv << [
                product.id, product.code, product.name,
                product.product_type, product.base_price, product.active ? 'Sí' : 'No',
                product.created_at.strftime('%d/%m/%Y %H:%M')
              ]
            end
          end
          
          send_data csv_data, filename: "products-#{Date.current}.csv", type: 'text/csv'
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

          # Filtros
          products = products.where(product_type: params[:type]) if params[:type].present?
          products = products.where(active: true) if params[:active] == 'true'
          products = products.where(active: false) if params[:inactive] == 'true'
          products = products.where(code: params[:code]) if params[:code].present?
          products = products.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
          products = products.where('base_price >= ?', params[:min_price]) if params[:min_price].present?
          products = products.where('base_price <= ?', params[:max_price]) if params[:max_price].present?
          
          # Rango de precios
          if params[:min_price].present?
            products = products.where('base_price >= ?', params[:min_price])
          end
          
          if params[:max_price].present?
            products = products.where('base_price <= ?', params[:max_price])
          end
          
          products
        end
        
        # app/controllers/api/v1/admin/products_controller.rb
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
            updated_at: product.updated_at,
            product_images: product.product_images.as_json(only: [:id, :url])
          }

          if product.vehicle?
            json[:vehicle] = {
              serial: product.vehicle&.serial,
              manufacture_year: product.vehicle&.manufacture_year,
              hours_used: product.vehicle&.hours_used,
              status: product.vehicle&.status,
              price_per_hour: product.vehicle&.price_per_hour&.to_f,
              price_per_day: product.vehicle&.price_per_day&.to_f,
              location: product.vehicle&.location,
              vehicle_model_id: product.vehicle&.vehicle_model_id,
              vehicle_model: product.vehicle&.vehicle_model&.model,
              vehicle_brand: product.vehicle&.vehicle_model&.brand,
              vehicle_type_id: product.vehicle&.vehicle_model&.vehicle_type_id,
              vehicle_type: product.vehicle&.vehicle_model&.vehicle_type&.name
            }
          elsif product.spare_part?
            json[:spare_part] = {
              part_number: product.spare_part&.part_number,
              manufacturer_brand: product.spare_part&.manufacturer_brand,
              stock: product.spare_part&.stock || 0,
              min_stock: product.spare_part&.min_stock || 5,
              sale_unit: product.spare_part&.sale_unit,
              is_critical: product.spare_part&.is_critical,
              category: product.spare_part&.spare_part_category&.name
            }
          end

          json
        end

        
        
        def product_params
          params.require(:product).permit(
            :product_type, :code, :name, :description, :base_price, :active, :created_by_id, :updated_by_id,
            vehicle_attributes: [
             :vehicle_model_id, :serial, :manufacture_year, :hours_used,
             :status, :price_per_hour, :price_per_day, :location
           ],
            spare_part_attributes: [
              :spare_part_category_id, :part_number, :manufacturer_brand, :stock,
              :min_stock, :sale_unit, :is_critical
            ],

            product_images_attributes: [:id, :url, :_destroy]
          )
        end
      end
    end
  end
end