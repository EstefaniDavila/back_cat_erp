class Api::V1::Client::InformationRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def create
    client = Client.find_by(id: params[:client_id])
    
    req = InformationRequest.new(
      client_id: client&.id,
      name: client ? client.business_name : params[:name],
      phone: client ? client.phone : params[:phone],
      subject: params[:subject],
      message: params[:message]
    )

    if req.save
      render json: { message: "Solicitud enviada exitosamente", information_request: req }, status: :created
    else
      render json: { message: "Error al enviar la solicitud", errors: req.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    if params[:client_id].present?
      requests = InformationRequest.where(client_id: params[:client_id]).order(created_at: :desc)
      render json: { information_requests: requests }, status: :ok
    else
      render json: { message: "client_id requerido" }, status: :bad_request
    end
  end
end
