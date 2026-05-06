module Api
  module V1
    module Admin
      class SuppliersController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :set_supplier, only: [:show, :update, :destroy]

        def index
          suppliers = Supplier.all.order(:business_name)
          render json: suppliers
        end

        def index_select
          suppliers = Supplier.select(:id, :code, :business_name).order(:business_name)
          render json: suppliers
        end

        def show
          render json: @supplier
        end

        def create
          supplier = Supplier.new(supplier_params)
          if supplier.save
            render json: supplier, status: :created
          else
            render json: { errors: supplier.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          if @supplier.update(supplier_params)
            render json: @supplier
          else
            render json: { errors: @supplier.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          @supplier.destroy
          head :no_content
        end

        private

        def set_supplier
          @supplier = Supplier.find(params[:id])
        end

        def supplier_params
          params.require(:supplier).permit(:code, :business_name, :document_type, :document_number, 
                                           :contact_name, :phone, :email, :address, :city, :status)
        end
      end
    end
  end
end