class Api::V1::Manager::RentalsController < ApplicationController
  include SearchHelper
  protect_from_forgery with: :null_session

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(',') || []
    rentals = Rental.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields2(fields, keywords, "text")
      rentals = rentals.ransack(search_conditions).result
    end
    total_records = rentals.count
    if params[:sort].present?
      field, order = paramos[:sort].split('%')
      rentals = rentals.order(field => order)
    else
      rentals = rentals.order(created_at: :desc)
    end
    rentals = rentals.page(params[:page]).per(params[:per_page])

    render json: {
      rentals: rentals.as_json(
        include: {
          client: {
            only: [:id, :business_name]
          },
          vehicle: {
            only: [:id],
            include: {
              product: { only: [:id, :name] }
            }
          },
        }
      ),
      current_page: rentals.current_page,
      total_pages: rentals.total_pages,
      per_page: rentals.limit_value,
      total_rentals: total_records,
    }, status: :ok
  end

  def create
    rental = Rental.new(rental_params)
    if rental.save
      render json: { message: "Alquiler registrado con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al registrar el alquiler", errors: rental.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    rental = Rental.find(params[:id])
    if rental.update(rental_params)
      render json: { message: "Alquiler actualizado con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al actualizar el alquiler", errors: rental.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    rental = Rental.find(params[:id])
    if rental.destroy
      render json: { message: "Alquiler eliminado con éxito" }, status: :ok
    else
      render json: { message: "Ocurrió un error al eliminar el alquiler", errors: rental.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def rental_params
    params.require(:rental).permit(:start_date, :end_date, :status, :delivery_date, :return_date, :vehicle_condition_delivery, :vehicle_condition_return, :total, :notes, :quotation_id, :client_id, :vehicle_id)
  end

end