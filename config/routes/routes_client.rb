Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :client do
        
        # --- RUTAS PÚBLICAS (LANDING PAGE) ---
        post '/public/request_quote', to: 'public#request_quote'

        # --- RUTAS PRIVADAS (PORTAL DE CLIENTES) ---
        # Estas requerirán autenticación en el futuro (current_user)
        get '/portal/quotations', to: 'portal#quotations'
        get '/portal/quotations/:id/pdf', to: 'portal#quotation_pdf'
        put '/portal/quotations/:id/approve', to: 'portal#approve_quotation'
        put '/portal/quotations/:id/reject', to: 'portal#reject_quotation'
        post '/portal/quotations/:id/comments', to: 'portal#add_comment'
        get '/portal/maintenances', to: 'portal#maintenances'
        get '/portal/orders', to: 'portal#orders'

      end
    end
  end
end
