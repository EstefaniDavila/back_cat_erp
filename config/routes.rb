Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'health', to: 'health#index'
      post 'health/toggle_chaos', to: 'health#toggle_chaos'
      post 'health/trigger_error', to: 'health#trigger_error'
      post 'support/classify_incident', to: 'support#classify_incident'
      
      namespace :general do
        api_guard_routes for: 'users', controller: {
          registration: 'users/registration',
          authentication: 'users/authentication',
          passwords: 'users/passwords',
          tokens: 'users/tokens'
        }
        post 'users/refresh', to: 'users/authentication#refresh'

        namespace :users2 do
          put '/update/', to: 'users#update_avatar'
        end
        post 'password/forgot_password',          to: 'password_recoveries#forgot_password'
        post 'password/forgot_password_by_phone', to: 'password_recoveries#forgot_password_by_phone'
        post 'password/validate_code',            to: 'password_recoveries#validate_code'
        post 'password/reset_password',           to: 'password_recoveries#reset_password'
      end
    end
  end

  Dir[Rails.root.join('config', 'routes', '*.rb')].each do |file|
    instance_eval(File.read(file))
  end
end
