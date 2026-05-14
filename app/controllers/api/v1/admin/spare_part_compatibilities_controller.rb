module Api
  module V1
    module Admin
      class SparePartCompatibilitiesController < ApplicationController
        before_action :set_compatibility, only: [:show, :destroy]
        before_action :set_spare_part, only: [:index_by_spare_part, :create, :bulk_create]

        def index
          compatibilities = SparePartCompatibility.all
          compatibilities = compatibilities.where(spare_part_id: params[:spare_part_id]) if params[:spare_part_id]
          compatibilities = compatibilities.where(vehicle_model_id: params[:vehicle_model_id]) if params[:vehicle_model_id]
          render json: compatibilities, include: [:spare_part, :vehicle_model]
        end

        def show
          render json: @compatibility, include: [:spare_part, :vehicle_model]
        end

        def index_by_spare_part
          compatibilities = @spare_part.spare_part_compatibilities.includes(:vehicle_model)
          render json: compatibilities, include: [:vehicle_model]
        end

        def create
          compatibility = @spare_part.spare_part_compatibilities.new(compatibility_params)
          if compatibility.save
            render json: compatibility, status: :created
          else
            render json: { errors: compatibility.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def bulk_create
          vehicle_model_ids = params[:vehicle_model_ids].is_a?(Array) ? params[:vehicle_model_ids] : [params[:vehicle_model_ids]]
          created = []

          ActiveRecord::Base.transaction do
            vehicle_model_ids.each do |vehicle_model_id|
              compatibility = @spare_part.spare_part_compatibilities.new(vehicle_model_id: vehicle_model_id)
              if compatibility.save
                created << compatibility
              else
                raise ActiveRecord::Rollback
                render json: { errors: compatibility.errors.full_messages }, status: :unprocessable_entity && return
              end
            end
          end

          render json: created, status: :created
        end

        def destroy
          @compatibility.destroy
          head :no_content
        end

        private

        def set_compatibility
          @compatibility = SparePartCompatibility.find(params[:id])
        end

        def set_spare_part
          @spare_part = SparePart.find(params[:spare_part_id])
        end

        def compatibility_params
          params.require(:spare_part_compatibility).permit(:vehicle_model_id)
        end
      end
    end
  end
end