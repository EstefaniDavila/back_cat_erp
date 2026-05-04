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

         ####################### Gestión de Tipos de Vehículo ##############################
        get    '/vehicle_types',                   to: 'vehicle_types#index'
        get    '/vehicle_types/select',             to: 'vehicle_types#index_select'
        get    '/vehicle_types/:id',                to: 'vehicle_types#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/vehicle_types',                    to: 'vehicle_types#create'
        put    '/vehicle_types/:id',                to: 'vehicle_types#update'
        patch  '/vehicle_types/:id',                to: 'vehicle_types#update'
        delete '/vehicle_types/destroy/:id',        to: 'vehicle_types#destroy'

        ####################### Gestión de Modelos de Vehículo ##############################
        get    '/vehicle_models',                   to: 'vehicle_models#index'
        get    '/vehicle_models/select',             to: 'vehicle_models#index_select'
        get    '/vehicle_models/:id',                to: 'vehicle_models#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/vehicle_models',                    to: 'vehicle_models#create'
        put    '/vehicle_models/:id',                to: 'vehicle_models#update'
        patch  '/vehicle_models/:id',                to: 'vehicle_models#update'
        
        ####################### Gestión de ESPECIFICACIONES DE MODELOS DE VEHÍCULO ##############################
        get    '/vehicle_model_specs',                   to: 'vehicle_model_specs#index'
        get    '/vehicle_model_specs/:id',               to: 'vehicle_model_specs#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/vehicle_model_specs',                   to: 'vehicle_model_specs#create'
        put    '/vehicle_model_specs/:id',               to: 'vehicle_model_specs#update'
        patch  '/vehicle_model_specs/:id',               to: 'vehicle_model_specs#update'
        delete '/vehicle_model_specs/:id',               to: 'vehicle_model_specs#destroy'
        
        # Rutas anidadas por modelo
        get    '/vehicle_models/:vehicle_model_id/specs', to: 'vehicle_model_specs#index_by_model'
        post   '/vehicle_models/:vehicle_model_id/specs/bulk_create', to: 'vehicle_model_specs#bulk_create'
        delete '/vehicle_models/:vehicle_model_id/specs/bulk_destroy', to: 'vehicle_model_specs#bulk_destroy'
        
        # Búsqueda
        get    '/vehicle_model_specs/search',            to: 'vehicle_model_specs#search'

        ####################### Gestión de VEHICULOS ##############################
        get    '/vehicles',                   to: 'vehicles#index'
        get    '/vehicles/:id',               to: 'vehicles#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/vehicles',                   to: 'vehicles#create'
        put    '/vehicles/:id',               to: 'vehicles#update'
        patch  '/vehicles/:id',               to: 'vehicles#update'
        delete '/vehicles/:id',               to: 'vehicles#destroy'

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


        ####################### CLIENTES ##############################
        get '/clients',                                       to: 'clients#index'
        get '/clients/:code',                                 to: 'clients#show'
        post '/clients',                                      to: 'clients#create'
        put '/clients/:id',                                   to: 'clients#update'
        delete '/clients/:id',                                to: 'clients#destroy'

        ####################### LEADS ##############################
        get '/leads',                                         to: 'leads#index'
        get '/leads/:code',                                   to: 'leads#show'
        put '/leads/:id',                                     to: 'leads#update'
        put '/leads/:id/assign/:advisor_id',                  to: 'leads#assign'

        ####################### QUOTATIONS #########################
        get '/quotations',                                    to: 'quotations#index'
        get '/quotations/:code',                              to: 'quotations#show'
        put '/quotations/:id/approve',                        to: 'quotations#approve'
        put '/quotations/:id/reject',                         to: 'quotations#reject'
        put '/quotations/:id/client_accept',                  to: 'quotations#client_accept'
        put '/quotations/:id',                                to: 'quotations#update'

        ####################### AREA REQUESTS ######################
        get '/area_requests',                                 to: 'area_requests#index'
        get '/area_requests/:id',                             to: 'area_requests#show'
        put '/area_requests/:id/reply',                       to: 'area_requests#reply'
      end
    end
  end
end