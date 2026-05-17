# app/controllers/api/v1/admin/purchase_orders_controller.rb

module Api
  module V1
    module Admin
      class PurchaseOrdersController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :set_purchase_order, only: [:show, :update, :destroy, :receive, :cancel, :download_guide]

        skip_before_action :verify_authenticity_token


        def index
          @purchase_orders = PurchaseOrder.includes(:supplier, :requested_by, :purchase_order_items)
                                          .all.order(created_at: :desc)
          render json: @purchase_orders, status: :ok
        end

        def index_select
          @purchase_orders = PurchaseOrder.select(:id, :code, :status, :total, :supplier_id)
          render json: @purchase_orders, status: :ok
        end

        def show
          render json: @purchase_order.as_json(
            include: {
              supplier: { only: [:id, :business_name, :code] },
              requested_by: { only: [:id, :email] },
              purchase_order_items: {
                include: { product: { only: [:id, :name, :code] } }
              }
            }
          ), status: :ok
        end

        def create
          @purchase_order = PurchaseOrder.new(purchase_order_params)
          #@purchase_order.requested_by_id = current_user.id
          @purchase_order.status = 'draft'

          if @purchase_order.save
            render json: @purchase_order, status: :created
          else
            render json: { errors: @purchase_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @purchase_order.update(purchase_order_params)
            render json: @purchase_order, status: :ok
          else
            render json: { errors: @purchase_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          if @purchase_order.draft?
            @purchase_order.destroy
            head :no_content
          else
            render json: { error: 'Only draft orders can be deleted' }, status: :unprocessable_entity
          end
        end

        def receive
          if @purchase_order.receive!
            # Opcional: crear stock movements aquí
            render json: @purchase_order, status: :ok
          else
            render json: { errors: @purchase_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def cancel
          if @purchase_order.update(status: 'cancelled')
            render json: @purchase_order, status: :ok
          else
            render json: { errors: @purchase_order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def by_supplier
          @purchase_orders = PurchaseOrder.where(supplier_id: params[:supplier_id])
          render json: @purchase_orders, status: :ok
        end

        def download_guide
          render json: {
            id: @purchase_order.id,
            code: @purchase_order.code,
            generated_at: Time.current,
            supplier: {
              business_name: @purchase_order.supplier&.business_name,
              document_number: @purchase_order.supplier&.document_number,
              phone: @purchase_order.supplier&.phone,
              address: @purchase_order.supplier&.address,
              email: @purchase_order.supplier&.email
            },
            expected_date: @purchase_order.expected_date,
            received_at: @purchase_order.received_at,
            status: @purchase_order.status,
            notes: @purchase_order.notes,
            items: @purchase_order.purchase_order_items.map do |item|
              {
                product_code: item.product&.code,
                product_name: item.product&.name,
                quantity: item.quantity,
                unit_cost: item.unit_cost.to_f,
                subtotal: (item.quantity * item.unit_cost).to_f
              }
            end,
            total: @purchase_order.total.to_f
          }, status: :ok
        end

        private

        def set_purchase_order
          @purchase_order = PurchaseOrder.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Purchase order not found' }, status: :not_found
        end

        def purchase_order_params
          params.require(:purchase_order).permit(
            :supplier_id, :requested_by_id, :expected_date, :received_at,:notes, :status,
            purchase_order_items_attributes: [:id, :product_id, :quantity, :unit_cost, :_destroy,]
          )

          
        end
      end
    end
  end
end