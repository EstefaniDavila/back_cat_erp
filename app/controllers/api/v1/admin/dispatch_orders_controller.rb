# app/controllers/api/v1/admin/dispatch_orders_controller.rb
module Api
  module V1
    module Admin
      class DispatchOrdersController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_dispatch_order, only: [:show, :update, :destroy, :process_dispatch, :deliver, :cancel]
        skip_before_action :verify_authenticity_token, raise: false

        # GET /api/v1/admin/dispatch_orders
       def index
        @dispatch_orders = DispatchOrder.includes(:prepared_by, :sales_order, :rental, :dispatch_items)
                                        .all.order(created_at: :desc)
        
        render json: @dispatch_orders.as_json(
          include: {
            prepared_by: { only: [:id, :full_name, :email] }
          }
        ), status: :ok
       end

        # GET /api/v1/admin/dispatch_orders/select
        def index_select
          @dispatch_orders = DispatchOrder.select(:id, :code, :status, :prepared_by_id)
          render json: @dispatch_orders, status: :ok
        end

        # GET /api/v1/admin/dispatch_orders/:id
        def show
          render json: @dispatch_order.as_json(
            include: {
              prepared_by: { only: [:id, :email, :full_name] },
              sales_order: { only: [:id, :code, :status] },
              rental: { only: [:id, :code, :status] },
              dispatch_items: {
                include: { product: { only: [:id, :name, :code] } }
              },
              delivery_guide: { only: [:id, :guide_number, :status] }
            }
          ), status: :ok
        end

        # POST /api/v1/admin/dispatch_orders
        def create
          @dispatch_order = DispatchOrder.new(dispatch_order_params)
          #@dispatch_order.prepared_by_id = current_user&.id || User.first&.id
          @dispatch_order.status = 'pending'
          generate_code(@dispatch_order)

          if @dispatch_order.save
            render json: @dispatch_order, status: :created
          else
            render json: { errors: @dispatch_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/dispatch_orders/:id
        def update
          if @dispatch_order.update(dispatch_order_params)
            render json: @dispatch_order, status: :ok
          else
            render json: { errors: @dispatch_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/dispatch_orders/:id
        def destroy
          if @dispatch_order.pending?
            @dispatch_order.destroy
            head :no_content
          else
            render json: { error: 'Only pending dispatch orders can be deleted' }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/dispatch_orders/:id/process_dispatch
        def process_dispatch
          if @dispatch_order.update(status: 'dispatched', dispatched_at: Time.current)
            render json: @dispatch_order, status: :ok
          else
            render json: { errors: @dispatch_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/dispatch_orders/:id/deliver
        def deliver
          if @dispatch_order.update(status: 'delivered', delivered_at: Time.current)
            render json: @dispatch_order, status: :ok
          else
            render json: { errors: @dispatch_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/dispatch_orders/:id/cancel
        def cancel
          if @dispatch_order.update(status: 'cancelled')
            render json: @dispatch_order, status: :ok
          else
            render json: { errors: @dispatch_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        # GET /api/v1/admin/dispatch_orders/by_status/:status
        def by_status
          @dispatch_orders = DispatchOrder.where(status: params[:status])
          render json: @dispatch_orders, status: :ok
        end

        # GET /api/v1/admin/dispatch_orders/by_sales_order/:sales_order_id
        def by_sales_order
          @dispatch_orders = DispatchOrder.where(sales_order_id: params[:sales_order_id])
          render json: @dispatch_orders, status: :ok
        end

        # GET /api/v1/admin/dispatch_orders/by_rental/:rental_id
        def by_rental
          @dispatch_orders = DispatchOrder.where(rental_id: params[:rental_id])
          render json: @dispatch_orders, status: :ok
        end

        private

        def set_dispatch_order
          @dispatch_order = DispatchOrder.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Dispatch order not found' }, status: :not_found
        end

        def dispatch_order_params
           params.require(:dispatch_order).permit(
            :code, :status, :sales_order_id, :rental_id, :prepared_by_id,
            dispatch_items_attributes: [:id, :product_id, :quantity, :checked, :_destroy]  # <--- AGREGAR ESTA LÍNEA
          )
        end

        def generate_code(order)
          return if order.code.present?
          order.code = "DISP-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
        end
      end
    end
  end
end