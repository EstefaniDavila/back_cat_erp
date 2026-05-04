Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :client do
        
        # --- RUTAS PÚBLICAS (LANDING PAGE) ---
        post '/public/request_quote', to: 'public#request_quote'

        # --- RUTAS PRIVADAS (PORTAL DE CLIENTES) ---
        # Estas requerirán autenticación en el futuro (current_user)
        # get '/my_quotations', to: 'portal#quotations'
        # get '/my_maintenances', to: 'portal#maintenances'

      end
    end
  end
end
