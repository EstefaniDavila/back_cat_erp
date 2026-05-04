# app/controllers/api/v1/admin/vehicle_model_specs_controller.rb
module Api
  module V1
    module Admin
      class VehicleModelSpecsController < ApplicationController
        #before_action :set_vehicle_model_spec, only: [:show, :update, :destroy]
        #before_action :set_vehicle_model, only: [:index_by_model]
        
        # Deshabilita CSRF para este controlador
        protect_from_forgery with: :null_session, only: [:create, :update, :destroy]

        # GET /api/v1/admin/vehicle_model_specs
        def index
          @specs = filtered_specs
                    .order(created_at: :desc)
                    .page(params[:page])
                    .per(params[:per_page] || 20)
          
          render json: {
            data: @specs.map { |s| spec_json(s) },
            meta: {
              current_page: @specs.current_page,
              total_pages: @specs.total_pages,
              total_count: @specs.total_count
            }
          }
        end
        
        # GET /api/v1/admin/vehicle_model_specs/:id
        def show
          render json: spec_json(@spec)
        end
        
        # GET /api/v1/admin/vehicle_models/:vehicle_model_id/specs
        def index_by_model
          @specs = @vehicle_model.vehicle_model_specs
                    .order(created_at: :desc)
          
          render json: {
            vehicle_model_id: @vehicle_model.id,
            vehicle_model_name: "#{@vehicle_model.brand} #{@vehicle_model.model}",
            specs: @specs.map { |s| spec_json(s) }
          }
        end
        
        # POST /api/v1/admin/vehicle_model_specs
        def create
          @spec = VehicleModelSpec.new(spec_params)
          
          if @spec.save
            render json: spec_json(@spec), status: :created
          else
            render json: { errors: @spec.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        # PUT/PATCH /api/v1/admin/vehicle_model_specs/:id
        def update
          if @spec.update(spec_params)
            render json: spec_json(@spec)
          else
            render json: { errors: @spec.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
        # DELETE /api/v1/admin/vehicle_model_specs/:id
        def destroy
          @spec.destroy
          head :no_content
        end
        
        # POST /api/v1/admin/vehicle_models/:vehicle_model_id/specs/bulk_create
        def bulk_create
          @vehicle_model = VehicleModel.find(params[:vehicle_model_id])
          specs_created = []
          errors = []
          
          params[:specs].each do |spec_data|
            spec = @vehicle_model.vehicle_model_specs.new(spec_data.permit(:key, :value, :unit))
            if spec.save
              specs_created << spec_json(spec)
            else
              errors << { key: spec_data[:key], errors: spec.errors.full_messages }
            end
          end
          
          if errors.empty?
            render json: { 
              message: "#{specs_created.count} especificaciones creadas correctamente",
              specs: specs_created
            }, status: :created
          else
            render json: { 
              partial_success: true,
              created: specs_created,
              errors: errors
            }, status: :multi_status
          end
        end
        
        # DELETE /api/v1/admin/vehicle_models/:vehicle_model_id/specs/bulk_destroy
        def bulk_destroy
          @vehicle_model = VehicleModel.find(params[:vehicle_model_id])
          @vehicle_model.vehicle_model_specs.destroy_all
          
          render json: { message: 'Todas las especificaciones fueron eliminadas' }
        end
        
        # GET /api/v1/admin/vehicle_model_specs/search
        def search
          @specs = VehicleModelSpec
                    .where('key ILIKE :q OR value ILIKE :q', q: "%#{params[:q]}%")
                    .includes(:vehicle_model)
                    .limit(10)
          
          render json: @specs.map { |s| spec_json(s) }
        end
        
        private
        
        def set_vehicle_model_spec
          @spec = VehicleModelSpec.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Especificación no encontrada' }, status: :not_found
        end
        
        def set_vehicle_model
          @vehicle_model = VehicleModel.find(params[:vehicle_model_id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Modelo de vehículo no encontrado' }, status: :not_found
        end
        
        def filtered_specs
          specs = VehicleModelSpec.all.includes(:vehicle_model)
          
          specs = specs.where(key: params[:key]) if params[:key].present?
          specs = specs.where(vehicle_model_id: params[:vehicle_model_id]) if params[:vehicle_model_id].present?
          
          specs
        end
        
        def spec_json(spec)
          {
            id: spec.id,
            key: spec.key,
            value: spec.value,
            unit: spec.unit,
            vehicle_model_id: spec.vehicle_model_id,
            vehicle_model: spec.vehicle_model ? "#{spec.vehicle_model.brand} #{spec.vehicle_model.model}" : nil,
            created_at: spec.created_at,
            updated_at: spec.updated_at
          }
        end
        
        def spec_params
          params.require(:vehicle_model_spec).permit(:key, :value, :unit, :vehicle_model_id)
        end
      end
    end
  end
end