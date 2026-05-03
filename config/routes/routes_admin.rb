Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :admin do
        #######################EJEEMPLOO##############################
        get '/areas',                                         to: 'areas#index'
        get '/areas/select',                                  to: 'areas#index_select'
        get '/areas_program/:code',                           to: 'areas#history'
        post '/areas',                                        to: 'areas#create'
        put '/areas/:id',                                     to: 'areas#update'
        delete '/areas/destroy/:id',                          to: 'areas#destroy'

        ####################### Gestión de Inventario===PRODUCTOS################################

        get    '/products',                   to: 'products#index'
        get    '/products/:id',               to: 'products#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        
        # Crear, actualizar y eliminar
        post   '/products',                   to: 'products#create'
        put    '/products/:id',               to: 'products#update'
        patch  '/products/:id',               to: 'products#update'
        delete '/products/:id',               to: 'products#destroy'
        
        # Acciones especiales
        patch  '/products/:id/toggle_active', to: 'products#toggle_active'
        get    '/products/search',            to: 'products#search'
        get    '/products/export_csv',        to: 'products#export_csv'


      end
    end
  end
end