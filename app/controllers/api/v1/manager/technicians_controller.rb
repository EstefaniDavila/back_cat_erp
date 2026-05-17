class Api::V1::Manager::TechniciansController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    technicians = Technician.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
      technicians = technicians.ransack(search_conditions).result
    end

    total_technicians = technicians.count

    if params[:sort].present?
      field, order = params[:sort].split("%")
      technicians = technicians.order("#{field} #{order}")
    else
      technicians = technicians.order(created_at: :desc)
    end

    page = params[:page] || 1
    page_size = params[:pageSize] || 10
    technicians = technicians.page(page).per(page_size)


    render json: {
      technicians: technicians.as_json(),
      current_page: technicians.current_page,
      total_pages: technicians.total_pages,
      per_page: technicians.limit_value,
      total_technicians: total_technicians,
    }, status: :ok
  end

  def list
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    technicians = Technician.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
      technicians = technicians.ransack(search_conditions).result
    end

    if params[:sort].present?
      field, order = params[:sort].split("%")
      technicians = technicians.order("#{field} #{order}")
    else
      technicians = technicians.order(created_at: :desc)
    end

    page = params[:page] || 1
    page_size = params[:pageSize] || 10
    technicians = technicians.page(page).per(page_size)

    technicians = technicians.map do |technician|
      {
        value: technician.id,
        label: technician.full_name,
      }
    end
    render json: {
      technicians: technicians.as_json(),
    }, status: :ok
  end

  # def show
  #   technician = Technician.find_by(code: params[:code]) || Technician.find_by(id: params[:id])
  #   if technician
  #     render json: {
  #       technician: {
  #         id: technician.id,
  #         **technician.attributes.symbolize_keys,
  #         created_at: technician.created_at.strftime("%d/%m/%Y %H:%M"),
  #       },
  #       status: :ok
  #     }
  #   else
  #     render json: { error: "Técnico no encontrado" }, status: :not_found
  #   end
  # end

  # def create
  #   technician = Technician.new(technician_params)
  #   technician.status = "active"

  #   if technician.save
  #     render json: { message: "El técnico fue creado exitosamente", technician: technician }, status: :ok
  #   else
  #     render json: { message: "Algo salió mal con la creación del técnico", errors: technician.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # def update
  #   technician = Technician.find(params[:id])
  #   if technician.update(technician_params)
  #     render json: { message: "Técnico actualizado con éxito", technician: technician }, status: :ok
  #   else
  #     render json: { message: "No se pudo actualizar el técnico", errors: technician.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   technician = Technician.find(params[:id])
  #   if technician.update(status: 'inactive')
  #     render json: { message: "Técnico desactivado exitosamente" }, status: :ok
  #   else
  #     render json: { message: technician.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # private

  # def technician_params
  #   params.require(:technician).permit(:name, :document_type, :document_number, :phone, :email, :address, :city, :status)
  # end
end
