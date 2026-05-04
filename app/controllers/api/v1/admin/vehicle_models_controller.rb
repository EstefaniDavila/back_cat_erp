module Api
  module V1
    module Admin
      class VehicleModelsController < ApplicationController
        #before_action :set_vehicle_model, only: [:show, :update, :destroy]

        # Deshabilita CSRF para este controlador
        protect_from_forgery with: :null_session, only: [:create, :update, :destroy]
        # GET /api/v1/admin/vehicle_models
        def index
          vehicle_models = VehicleModel.all
          
          # Filtrar por tipo de vehículo si se especifica
          if params[:vehicle_type_id].present?
            vehicle_models = vehicle_models.where(vehicle_type_id: params[:vehicle_type_id])
          end
          
          vehicle_models = vehicle_models.order(created_at: :desc)
          
          render json: {
            data: vehicle_models,
            total: vehicle_models.count
          }, status: :ok
        end

        # GET /api/v1/admin/vehicle_models/select
        def index_select
          vehicle_models = VehicleModel.all.select(:id, :brand, :model).order(:brand, :model)
          
          render json: {
            data: vehicle_models
          }, status: :ok
        end

        # GET /api/v1/admin/vehicle_models/:id
        def show
          render json: @vehicle_model, status: :ok
        end

        # POST /api/v1/admin/vehicle_models
        def create
          vehicle_model = VehicleModel.new(vehicle_model_params)
          
          if vehicle_model.save
            render json: {
              message: "Modelo de vehículo creado exitosamente",
              data: vehicle_model
            }, status: :created
          else
            render json: {
              errors: vehicle_model.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/vehicle_models/:id
        def update
          if @vehicle_model.update(vehicle_model_params)
            render json: {
              message: "Modelo de vehículo actualizado exitosamente",
              data: @vehicle_model
            }, status: :ok
          else
            render json: {
              errors: @vehicle_model.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/vehicle_models/destroy/:id
        def destroy
          # Verificar si tiene vehículos asociados
          if @vehicle_model.vehicles.exists?
            render json: {
              errors: ["No se puede eliminar porque tiene #{@vehicle_model.vehicles.count} vehículo(s) asociado(s)"]
            }, status: :conflict
          else
            @vehicle_model.destroy
            render json: {
              message: "Modelo de vehículo eliminado exitosamente"
            }, status: :ok
          end
        end

        private

        def set_vehicle_model
          @vehicle_model = VehicleModel.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: {
            errors: ["Modelo de vehículo no encontrado"]
          }, status: :not_found
        end

        def vehicle_model_params
          params.require(:vehicle_model).permit(
            :brand, :model, :power_hp, :weight_ton, 
            :capacity_m3, :active, :vehicle_type_id
          )
        end
      end
    end
  end
end