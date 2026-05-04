module Api
  module V1
    module Admin
      class SparePartSpecsController < ApplicationController
        before_action :set_spec, only: [:show, :update, :destroy]
        before_action :set_spare_part, only: [:index_by_spare_part, :create, :bulk_create]

        def index
          specs = SparePartSpec.all
          specs = specs.where(spare_part_id: params[:spare_part_id]) if params[:spare_part_id]
          render json: specs
        end

        def show
          render json: @spec
        end

        def index_by_spare_part
          specs = @spare_part.spare_part_specs
          render json: specs
        end

        def create
          spec = @spare_part.spare_part_specs.new(spec_params)
          if spec.save
            render json: spec, status: :created
          else
            render json: { errors: spec.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def bulk_create
          specs = params[:specs].is_a?(Array) ? params[:specs] : [params[:specs]]
          created = []

          ActiveRecord::Base.transaction do
            specs.each do |spec_data|
              spec = @spare_part.spare_part_specs.new(spec_data.permit(:key, :value, :unit))
              if spec.save
                created << spec
              else
                raise ActiveRecord::Rollback
                render json: { errors: spec.errors.full_messages }, status: :unprocessable_entity && return
              end
            end
          end

          render json: created, status: :created
        end

        def update
          if @spec.update(spec_params)
            render json: @spec
          else
            render json: { errors: @spec.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @spec.destroy
          head :no_content
        end

        def bulk_destroy
          spec_ids = params[:spec_ids].is_a?(Array) ? params[:spec_ids] : [params[:spec_ids]]
          SparePartSpec.where(id: spec_ids).destroy_all
          head :no_content
        end

        private

        def set_spec
          @spec = SparePartSpec.find(params[:id])
        end

        def set_spare_part
          @spare_part = SparePart.find(params[:spare_part_id])
        end

        def spec_params
          params.require(:spare_part_spec).permit(:key, :value, :unit)
        end
      end
    end
  end
end