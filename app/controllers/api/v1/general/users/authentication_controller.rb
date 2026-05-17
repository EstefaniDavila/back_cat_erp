module Users
  class Api::V1::General::Users::AuthenticationController < ApiGuard::AuthenticationController
    include Loggable
    before_action :find_resource, only: [:create]
    before_action :authenticate_resource, only: [:destroy]

    # def refresh
    #   authenticate_resource
    #   create_token_and_set_header(current_resource, resource_name)

    #   render json: {
    #     access_token: response.headers['Access-Token'],
    #     refresh_token: response.headers['Refresh-Token'],
    #     expire_at: response.headers['Expire-At']
    #   }
    # end

    def refresh
      refresh_token = params[:refresh_token]
      return render json: { error: "refresh_token required" }, status: 400 if refresh_token.blank?
      stored_token = RefreshToken.find_by(token: refresh_token)
      return render json: { error: "Invalid refresh token" }, status: 401 if stored_token.nil?
      return render json: { error: "Expired refresh token" }, status: 401 if stored_token.expire_at < Time.current
      user = stored_token.user
      stored_token.destroy
      new_refresh = user.refresh_tokens.create!(
        token: SecureRandom.hex(64),
        expire_at: 1.week.from_now
      )
      create_token_and_set_header(user, :user)
      render json: {
        access_token: response.headers["Access-Token"],
        refresh_token: new_refresh.token,
        expire_at: response.headers["Expire-At"]
      }
    end

    def create
      if resource.authenticate(params[:authentication][:password])
        create_token_and_set_header(resource, resource_name)
        log_activity("Inicio de sesión exitoso", nil, resource)
        refresh_token = resource.refresh_tokens.create!(
          token: SecureRandom.hex(64),
          expire_at: 1.week.from_now
        )
        render json: {
          message: "Bienvenido a al ERP de Caterpillar",
          access_token: response.headers['Access-Token'],
          # refresh_token: response.headers['Refresh-Token'],
          refresh_token: refresh_token.token,
          expire_at: response.headers["Expire-At"],
          user: {
            **resource.attributes.symbolize_keys,
            full_name: resource.full_name,
            roleable: resource.roleable&.as_json
          },
          # rol: resource.roleable_id,
          rol: resource.roleable_type
        }, status: :ok
      else
        render_error(422, message: I18n.t('api_guard.authentication.invalid_login_credentials'))
      end
    end

    def destroy
      token = request.headers['Authorization']&.split(' ')&.last
      if token.present?
        BlacklistedToken.create!(
          token: token,
          user: current_resource,
          expire_at: Time.current + 1.day
        )
      end
      log_activity("Cierre de sesión", nil, current_resource)
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
      if params[:authentication].present? && params[:authentication][:password].present?
        password = params[:authentication][:password]
        # debugger
        if params[:authentication][:document_number].present?
          login_value = params[:authentication][:document_number].downcase.strip
          self.resource = User.find_by("document_number = ?", login_value)
        elsif params[:authentication][:email].present?
          login_value = params[:authentication][:email].downcase.strip
          self.resource = User.find_by("email = ?", login_value)
        else
          puts "Missing email or document_number"
          return render_error(422, message: I18n.t('api_guard.authentication.invalid_login_credentials'))
        end
    
        if resource
          begin
            if resource.authenticate(password)
              return
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
    
      log_activity("Intento de inicio de sesión fallido", "Credenciales inválidas para: #{params.dig(:authentication, :email) || params.dig(:authentication, :document_number)}")
      render_error(422, message: I18n.t('api_guard.authentication.invalid_login_credentials'))
    end
    
  end
end