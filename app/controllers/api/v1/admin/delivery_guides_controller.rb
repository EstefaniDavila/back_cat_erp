# app/controllers/api/v1/admin/delivery_guides_controller.rb
module Api
  module V1
    module Admin
      class DeliveryGuidesController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_delivery_guide, only: [:show, :update, :destroy, :mark_as_issued, :mark_as_delivered]
        skip_before_action :verify_authenticity_token, raise: false

        # GET /api/v1/admin/delivery_guides
        def index
          @delivery_guides = DeliveryGuide.includes(:dispatch_order, :driver, :vehicle)
                                          .all.order(created_at: :desc)
          render json: @delivery_guides, status: :ok
        end

        # GET /api/v1/admin/delivery_guides/:id
        def show
          render json: @delivery_guide.as_json(
            include: {
              dispatch_order: { only: [:id, :code, :status] },
              driver: { only: [:id, :full_name, :email] },
              vehicle: { only: [:id, :plate_number, :model] }
            }
          ), status: :ok
        end

        # GET /api/v1/admin/dispatch_orders/:dispatch_order_id/delivery_guide
        def by_dispatch_order
          @delivery_guide = DeliveryGuide.find_by(dispatch_order_id: params[:dispatch_order_id])
          if @delivery_guide
            render json: @delivery_guide, status: :ok
          else
            render json: { error: 'Delivery guide not found for this dispatch order' }, status: :not_found
          end
        end

        # POST /api/v1/admin/delivery_guides
        def create
          @delivery_guide = DeliveryGuide.new(delivery_guide_params)
          @delivery_guide.status = 'pending'
          generate_guide_number(@delivery_guide)

          if @delivery_guide.save
            render json: @delivery_guide, status: :created
          else
            render json: { errors: @delivery_guide.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/delivery_guides/:id
        def update
          if @delivery_guide.update(delivery_guide_params)
            render json: @delivery_guide, status: :ok
          else
            render json: { errors: @delivery_guide.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/delivery_guides/:id
        def destroy
          if @delivery_guide.pending?
            @delivery_guide.destroy
            head :no_content
          else
            render json: { error: 'Only pending delivery guides can be deleted' }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/delivery_guides/:id/mark_as_issued
        def mark_as_issued
          if @delivery_guide.update(status: 'issued', issued_at: Time.current)
            render json: @delivery_guide, status: :ok
          else
            render json: { errors: @delivery_guide.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PATCH /api/v1/admin/delivery_guides/:id/mark_as_delivered
        def mark_as_delivered
          if @delivery_guide.update(status: 'delivered', delivered_at: Time.current)
            render json: @delivery_guide, status: :ok
          else
            render json: { errors: @delivery_guide.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def set_delivery_guide
          @delivery_guide = DeliveryGuide.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Delivery guide not found' }, status: :not_found
        end

        def delivery_guide_params
          params.require(:delivery_guide).permit(
            :guide_number, :destination_address, :status, 
            :dispatch_order_id, :driver_id, :vehicle_id
          )
        end

        def generate_guide_number(guide)
          return if guide.guide_number.present?
          guide.guide_number = "GUI-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
        end
      end
    end
  end
end

