module Users
  class Api::V1::General::Users::AuthenticationController < ApiGuard::AuthenticationController
    before_action :find_resource, only: [:create]
    before_action :authenticate_resource, only: [:destroy]

    def create
      if resource.authenticate(params[:authentication][:password])
        create_token_and_set_header(resource, resource_name)
        # full_name = Admin.find_by(document_number: resource.document_number)
        render json: {
          message: "Bienvenido a al ERP de Caterpillar",
          access_token: response.headers['Access-Token'],
          refresh_token: response.headers['Refresh-Token'],
          expire_at: response.headers["Expire-At"],
          user: {
            **resource.attributes.symbolize_keys,
            # full_name: full_name.full_name
            full_name: resource.roleable&.full_name
          },
          # rol: resource.roleable_id,
          rol: resource.roleable_type
        }, status: :ok
      else
        render_error(422, message: I18n.t('api_guard.authentication.invalid_login_credentials'))
      end
    end

    def destroy
      blacklist_token
      render_success(message: I18n.t('api_guard.authentication.signed_out'))
    end

    private

    def generate_aud_token(user_id, os_data, remote_ip, browser_data)
      payload = {
        user_id: user_id,
        os_data: os_data,
        remote_ip: remote_ip,
        browser_data: browser_data,
        exp: Time.now.to_i + 1.month.to_i
      }

      secret_key = 'tu_clave_secreta'

      token = JWT.encode(payload, PRIVATE_KEY, 'RS256')
      token
    end

    def verify_aud_token(token)
      decoded_token = JWT.decode(token, PUBLIC_KEY, true, algorithm: 'RS256')
      decoded_token
    rescue JWT::DecodeError
      nil
    end

    # def find_resource
    #   if params[:authentication].present? && params[:authentication][:document_number].present? && params[:authentication][:password].present?
    #     self.resource = resource_class.find_by("document_number = ?", params[:authentication][:document_number].downcase.strip)
    #     debugger
    #     if resource && resource.authenticate(params[:authentication][:password])
    #       debugger
    #       return
    #     end
    #   end
    #   render_error(422, message: I18n.t('api_guard.authentication.invalid_login_credentials'))
    # end
    def find_resource
      if params[:authentication].present? && params[:authentication][:document_number].present? && params[:authentication][:password].present?
        document_number = params[:authentication][:document_number].downcase.strip
        password = params[:authentication][:password]
        
        puts "Document number: #{document_number}"
        puts "Password: #{password}"
    
        self.resource = User.find_by("document_number = ?", document_number)
    
        if resource
          puts "User found: #{resource.inspect}"
          
          begin
            if resource.authenticate(password)
              puts "Authentication successful"
              return
            else
              puts "Authentication failed"
            end
          rescue BCrypt::Errors::InvalidHash => e
            puts "Invalid password hash: #{e.message}"
          end
        else
          puts "User not found"
        end
      else
        puts "Missing parameters"
      end
    
      render_error(422, message: I18n.t('api_guard.authentication.invalid_login_credentials'))
    end
    
  end
end