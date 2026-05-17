# app/controllers/api/v1/admin/vehicles_controller.rb
module Api
  module V1
    module Admin
      class VehiclesController < ApplicationController
        protect_from_forgery with: :null_session
        
        before_action :set_vehicle, only: [:show, :update, :destroy, :disable, :enable, :maintenance, :make_available]

        # GET /api/v1/admin/vehicles
        def index
          @vehicles = filtered_vehicles
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(params[:per_page] || 20)
          
          render json: {
            data: @vehicles.map { |v| vehicle_json(v) },
            meta: {
              current_page: @vehicles.current_page,
              total_pages: @vehicles.total_pages,
              total_count: @vehicles.total_count
            }
          }
        end
        
        # GET /api/v1/admin/vehicles/:id
        def show
          render json: vehicle_json(@vehicle)
        end
        
        # POST /api/v1/admin/vehicles
        def create
          @vehicle = Vehicle.new(vehicle_params)
          
          if @vehicle.save
            render json: vehicle_json(@vehicle), status: :created
          else
            render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        # PUT/PATCH /api/v1/admin/vehicles/:id
        def update
          if @vehicle.update(vehicle_params)
            render json: vehicle_json(@vehicle)
          else
            render json: { errors: @vehicle.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        # DELETE /api/v1/admin/vehicles/:id
        def destroy
          # Verificar si el vehículo tiene transacciones asociadas
          if @vehicle.rentals.exists? || @vehicle.delivery_guides.exists?
            render json: { error: 'No se puede eliminar el vehículo porque tiene transacciones asociadas' }, 
                   status: :unprocessable_entity
          else
            @vehicle.destroy
            head :no_content
          end
        end

        # PATCH /api/v1/admin/vehicles/:id/disable
        def disable
          @vehicle.mark_as_disabled!
          render json: { success: true, vehicle: vehicle_json(@vehicle) }
        end

        # PATCH /api/v1/admin/vehicles/:id/enable
        def enable
          @vehicle.mark_as_available!
          render json: { success: true, vehicle: vehicle_json(@vehicle) }
        end

        # PATCH /api/v1/admin/vehicles/:id/maintenance
        def maintenance
          @vehicle.mark_as_maintenance!
          render json: { success: true, vehicle: vehicle_json(@vehicle) }
        end

        # PATCH /api/v1/admin/vehicles/:id/make_available
        def make_available
          @vehicle.mark_as_available!
          render json: { success: true, vehicle: vehicle_json(@vehicle) }
        end

        

        private
        
        def set_vehicle
          @vehicle = Vehicle.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Vehículo no encontrado' }, status: :not_found
        end
        
        def filtered_vehicles
          vehicles = Vehicle.all.includes(:product, :vehicle_model)
          
          # Filtros
          vehicles = vehicles.where(status: params[:status]) if params[:status].present?
          vehicles = vehicles.where(location: params[:location]) if params[:location].present?
          vehicles = vehicles.where('manufacture_year >= ?', params[:year_from]) if params[:year_from].present?
          vehicles = vehicles.where('manufacture_year <= ?', params[:year_to]) if params[:year_to].present?
          
          # Filtro por modelo
          if params[:vehicle_model_id].present?
            vehicles = vehicles.where(vehicle_model_id: params[:vehicle_model_id])
          end
          
          # Filtro por producto/código
          if params[:product_code].present?
            vehicles = vehicles.joins(:product).where(products: { code: params[:product_code] })
          end
          
          vehicles
        end
        
        def vehicle_json(vehicle)
          {
            id: vehicle.id,
            product_id: vehicle.product_id,
            product_code: vehicle.product&.code,
            product_name: vehicle.product&.name,
            serial: vehicle.serial,
            manufacture_year: vehicle.manufacture_year,
            hours_used: vehicle.hours_used.to_f,
            status: vehicle.status,
            price_per_hour: vehicle.price_per_hour.to_f,
            price_per_day: vehicle.price_per_day.to_f,
            location: vehicle.location,
            vehicle_model_id: vehicle.vehicle_model_id,
            vehicle_model: vehicle.vehicle_model&.model,
            vehicle_brand: vehicle.vehicle_model&.brand,
            created_at: vehicle.created_at,
            updated_at: vehicle.updated_at
          }
        end
        
        def vehicle_params
          params.require(:vehicle).permit(
            :product_id, :vehicle_model_id, :serial, :manufacture_year,
            :hours_used, :status, :price_per_hour, :price_per_day, :location
          )
        end
      end
    end
  end
end