module Api
  module V1
    module Admin
      class SparePartCompatibilitiesController < ApplicationController
        before_action :set_spare_part

        def index
          compatibilities = @spare_part.spare_part_compatibilities.includes(:vehicle_model)
          render json: compatibilities.map { |c| compatibility_json(c) }
        end

        def create
          compatibility = @spare_part.spare_part_compatibilities.new(compatibility_params)
          if compatibility.save
            render json: compatibility_json(compatibility), status: :created
          else
            render json: { errors: compatibility.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          compatibility = @spare_part.spare_part_compatibilities.find(params[:id])
          compatibility.destroy
          head :no_content
        end

        private

        def set_spare_part
          @spare_part = SparePart.find(params[:spare_part_id])
        end

        def compatibility_params
          params.require(:spare_part_compatibility).permit(:vehicle_model_id)
        end

        def compatibility_json(compatibility)
          {
            id: compatibility.id,
            vehicle_model_id: compatibility.vehicle_model_id,
            vehicle_model_name: compatibility.vehicle_model&.model,
            brand: compatibility.vehicle_model&.brand
          }
        end
      end
    end
  end
end