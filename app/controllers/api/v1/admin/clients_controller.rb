class Api::V1::Admin::ClientsController < ApplicationController
  include SearchHelper
  
  # skip_before_action :verify_authenticity_token
  # before_action :authenticate_and_set_user 

  def index
    keywords = params[:search_params] || ""
    fields = params[:search_fields]&.split(",") || []
    clients = Client.all

    if fields.present? && keywords.present?
      search_conditions = combine_search_fields(fields, keywords, "cont")
      clients = clients.ransack(search_conditions).result
    end

    total_clients = clients.count

    if params[:sort].present?
      field, order = params[:sort].split("%")
      clients = clients.order("#{field} #{order}")
    else
      clients = clients.order(created_at: :desc)
    end

    page = params[:page] || 1
    page_size = params[:pageSize] || 10
    clients = clients.page(page).per(page_size)

    clients_data = clients.map do |client|
      {
        id: client.id,
        **client.attributes.symbolize_keys,
        created_at: client.created_at.strftime("%d/%m/%Y %H:%M"),
        updated_at: client.updated_at.strftime("%d/%m/%Y %H:%M")
      }
    end

    render json: {
      clients: clients_data,
      current_page: clients.current_page,
      total_pages: clients.total_pages,
      per_pages: clients.limit_value,
      total_clients: total_clients
    }, status: :ok
  end

  def show
    client = Client.find_by(code: params[:code]) || Client.find_by(id: params[:id])
    if client
      render json: {
        client: {
          id: client.id,
          **client.attributes.symbolize_keys,
          created_at: client.created_at.strftime("%d/%m/%Y %H:%M"),
        },
        status: :ok
      }
    else
      render json: { error: "Cliente no encontrado" }, status: :not_found
    end
  end

  def create
    client = Client.new(client_params)
    client.status = "active"

    if client.save
      render json: { message: "El cliente fue creado exitosamente", client: client }, status: :ok
    else
      render json: { message: "Algo salió mal con la creación del cliente", errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    client = Client.find(params[:id])
    if client.update(client_params)
      render json: { message: "Cliente actualizado con éxito", client: client }, status: :ok
    else
      render json: { message: "No se pudo actualizar el cliente", errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    client = Client.find(params[:id])
    if client.update(status: 'inactive')
      render json: { message: "Cliente desactivado exitosamente" }, status: :ok
    else
      render json: { message: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:business_name, :document_type, :document_number, :contact_name, :phone, :email, :address, :city, :status)
  end
end
