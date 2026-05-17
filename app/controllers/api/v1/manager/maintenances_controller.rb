class Api::V1::Manager::MaintenancesController < ApplicationController
  include SearchHelper
  skip_before_action :verify_authenticity_token

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    maintenances = Maintenance.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      maintenances = maintenances.ransack(search_conditions).result
    end
    total_records = maintenances.count
    if params[:sort].present?
      field, order = paramos[:sort].split('%')
      maintenances = maintenances.order(field => order)
    else
      maintenances = maintenances.order(created_at: :desc)
    end
    maintenances = maintenances.page(params[:page]).per(params[:per_page])

    render json: {
      maintenances: maintenances.as_json(
        include: {
          client: {
            only: [:id, :business_name]
          },
          enterprise_vehicle: {
            only: [:id, :serial]
          }
        }
      ),
      current_page: maintenances.current_page,
      total_pages: maintenances.total_pages,
      per_page: maintenances.limit_value,
      total_maintenances: total_records,
    }, status: :ok
  end

  def create
    maintenance = Maintenance.new(maintenance_params)
    if maintenance.save
      render json: { message: "Mantenimiento registrado con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al registrar el mantenimiento", errors: maintenance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    maintenance = Maintenance.find(params[:id])
    if maintenance.update(maintenance_params)
      render json: { message: "Mantenimiento actualizado con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al actualizar el mantenimiento", errors: maintenance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    maintenance = Maintenance.find(params[:id])
    if maintenance.work_orders.empty? && maintenance.maintenance_reports.empty?
      maintenance.destroy
      render json: { message: "Mantenimiento eliminado con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al eliminar el mantenimiento", errors: maintenance.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def maintenance_params
    params.require(:maintenance).permit(:description, :maintenance_type, :priority, :status, :requested_at, :scheduled_at, :completed_at, :client_id, :customer_asset_id, :enterprise_vehicle_id, :quotation_id)
  end

end