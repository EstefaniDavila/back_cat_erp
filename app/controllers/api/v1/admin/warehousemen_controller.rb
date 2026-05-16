# app/controllers/api/v1/admin/warehousemen_controller.rb
module Api
  module V1
    module Admin
      class WarehousemenController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
        before_action :set_warehouseman, only: [:show, :update, :destroy]

        # GET /api/v1/admin/warehousemen
        def index
          @warehousemen = Warehouseman.all.order(:full_name)
          render json: @warehousemen, status: :ok
        end

        # GET /api/v1/admin/warehousemen/select
        def index_select
          @warehousemen = Warehouseman.select(:id, :full_name, :email, :document_number)
                                      .order(:full_name)
          render json: @warehousemen, status: :ok
        end

        # GET /api/v1/admin/warehousemen/:id
        def show
          render json: @warehouseman, status: :ok
        end

        # POST /api/v1/admin/warehousemen
        def create
          @warehouseman = Warehouseman.new(warehouseman_params)

          if @warehouseman.save
            render json: @warehouseman, status: :created
          else
            render json: { errors: @warehouseman.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/warehousemen/:id
        def update
          if @warehouseman.update(warehouseman_params)
            render json: @warehouseman, status: :ok
          else
            render json: { errors: @warehouseman.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/warehousemen/:id
        def destroy
          @warehouseman.destroy
          head :no_content
        end

        private

        def set_warehouseman
          @warehouseman = Warehouseman.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Warehouseman not found' }, status: :not_found
        end

        def warehouseman_params
          params.require(:warehouseman).permit(
            :first_name, :last_name, :full_name, :email, 
            :document_number, :document_type, :position
          )
        end
      end
    end
  end
end