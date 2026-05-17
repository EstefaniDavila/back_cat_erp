module Api
  module V1
    module Warehouse
      class SuppliersController < ApplicationController        
        # GET /api/v1/Warehouse/suppliers
        def index
          suppliers = Supplier.all.order(:business_name)
          render json: suppliers
        end

        # GET /api/v1/Warehouse/suppliers/select
        def index_select
          suppliers = Supplier.select(:id, :code, :business_name).order(:business_name)
          render json: suppliers
        end

        # GET /api/v1/Warehouse/suppliers/:id
        def show
          supplier = Supplier.find(params[:id])
          render json: supplier
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Supplier not found' }, status: :not_found
        end
      end
    end
  end
end