# app/controllers/api/v1/admin/vehicle_types_controller.rb
module Api
  module V1
    module Admin
      class VehicleTypesController < ApplicationController

        #before_action :set_vehicle_type, only: [:show, :update, :destroy]

        # Deshabilita CSRF para este controlador
        protect_from_forgery with: :null_session, only: [:create, :update, :destroy]

        # GET /api/v1/admin/vehicle_types
        def index
          vehicle_types = VehicleType.all.order(created_at: :desc)
          
          render json: {
            data: vehicle_types,
            total: vehicle_types.count
          }, status: :ok
        end

        # GET /api/v1/admin/vehicle_types/select (para dropdowns)
        def index_select
          vehicle_types = VehicleType.all.select(:id, :name).order(:name)
          
          render json: {
            data: vehicle_types
          }, status: :ok
        end

        # GET /api/v1/admin/vehicle_types/:id
        def show
          render json: @vehicle_type, status: :ok
        end

        # POST /api/v1/admin/vehicle_types
        def create
          vehicle_type = VehicleType.new(vehicle_type_params)
          
          if vehicle_type.save
            render json: {
              message: "Tipo de vehículo creado exitosamente",
              data: vehicle_type
            }, status: :created
          else
            render json: {
              errors: vehicle_type.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/vehicle_types/:id
        def update
          if @vehicle_type.update(vehicle_type_params)
            render json: {
              message: "Tipo de vehículo actualizado exitosamente",
              data: @vehicle_type
            }, status: :ok
          else
            render json: {
              errors: @vehicle_type.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/vehicle_types/destroy/:id
        def destroy
          # Verificar si tiene modelos asociados
          if @vehicle_type.vehicle_models.exists?
            render json: {
              errors: ["No se puede eliminar porque tiene #{@vehicle_type.vehicle_models.count} modelo(s) asociado(s)"]
            }, status: :conflict
          else
            @vehicle_type.destroy
            render json: {
              message: "Tipo de vehículo eliminado exitosamente"
            }, status: :ok
          end
        end

        private

        def set_vehicle_type
          @vehicle_type = VehicleType.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: {
            errors: ["Tipo de vehículo no encontrado"]
          }, status: :not_found
        end

        def vehicle_type_params
          params.require(:vehicle_type).permit(:name, :description)
        end
      end
    end
  end
end