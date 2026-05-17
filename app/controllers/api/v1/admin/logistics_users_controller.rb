# app/controllers/api/v1/admin/logistics_users_controller.rb
module Api
  module V1
    module Admin
      class LogisticsUsersController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
        before_action :set_logistics_user, only: [:show, :update, :destroy]

        # GET /api/v1/admin/logistics_users
        def index
          @logistics_users = LogisticsUser.all.order(:full_name)
          render json: @logistics_users, status: :ok
        end

        # GET /api/v1/admin/logistics_users/select
        def index_select
          @logistics_users = LogisticsUser.select(:id, :full_name, :email, :document_number)
                                          .order(:full_name)
          render json: @logistics_users, status: :ok
        end

        # GET /api/v1/admin/logistics_users/:id
        def show
          render json: @logistics_user, status: :ok
        end

        # POST /api/v1/admin/logistics_users
        def create
          @logistics_user = LogisticsUser.new(logistics_user_params)

          if @logistics_user.save
            render json: @logistics_user, status: :created
          else
            render json: { errors: @logistics_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT/PATCH /api/v1/admin/logistics_users/:id
        def update
          if @logistics_user.update(logistics_user_params)
            render json: @logistics_user, status: :ok
          else
            render json: { errors: @logistics_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/logistics_users/:id
        def destroy
          @logistics_user.destroy
          head :no_content
        end

        private

        def set_logistics_user
          @logistics_user = LogisticsUser.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Logistics user not found' }, status: :not_found
        end

        def logistics_user_params
          params.require(:logistics_user).permit(
            :first_name, :last_name, :full_name, :email, 
            :document_number, :document_type, :position
          )
        end
      end
    end
  end
end