module Users
  class Api::V1::General::Users::PasswordsController < ApiGuard::PasswordsController
    before_action :authenticate_resource, only: [:update]

    def update
      user = current_resource

      unless user&.authenticate(params[:old_password])
        return render_error(422, message: 'Old password is incorrect.')
      end

      if user.update(password_params)

        invalidate_old_jwt_tokens(user)
        blacklist_token unless ApiGuard.invalidate_old_tokens_on_password_change
        destroy_all_refresh_tokens(user)

        create_token_and_set_header(user, resource_name)

        new_access_token = response.headers['Access-Token']
        new_refresh_token = response.headers['Refresh-Token']
        expire_at = response.headers['Expire-At']


        render json: { 
          message: I18n.t('api_guard.password.changed'),
          access_token: new_access_token,
          expires_at: expire_at,
          refresh_token: new_refresh_token
        }, status: :ok
      else
        Rails.logger.error "Error al actualizar la contraseña para el usuario: #{user.inspect}"
        render_error(422, message: 'Password update failed.')
      end
    rescue => e
      Rails.logger.error "Error en el controlador de passwords: #{e.message}"
      render_error(500, message: 'Token generation failed: ' + e.message)
    end

    private

    def password_params
      params.permit(:password, :password_confirmation)
    end
  end
end