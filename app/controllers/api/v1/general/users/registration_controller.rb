module Users
  class Api::V1::General::Users::RegistrationController < ApiGuard::RegistrationController
    # before_action :authenticate_resource, only: [:destroy]

    def create
      init_resource(sign_up_params)

      # Buscamos o creamos un cliente con el documento proporcionado para asignarlo al usuario
      client = Client.find_or_create_by(document_number: sign_up_params[:document_number]) do |c|
        c.email = sign_up_params[:email]
        c.document_type = "DNI" # Valor por defecto
        c.business_name = "Cliente #{sign_up_params[:document_number]}"
        c.status = "active"
      end

      resource.roleable = client

      if resource.save
        create_token_and_set_header(resource, resource_name)
        render_success(message: I18n.t('api_guard.registration.signed_up'))
      else
        render json: { error: resource.errors.full_messages.join(", ") }, status: 422
      end
    end
  
    private
  
    def sign_up_params
      params.permit(:email, :document_number, :password, :password_confirmation, :avatar)
    end
    
    # def destroy
    #   current_resource.destroy
    #   render_success(message: I18n.t('api_guard.registration.account_deleted'))
    # end

  end
end
