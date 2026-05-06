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
       ####################### Categorías de Repuestos ##############################
        get    '/spare_part_categories',                   to: 'spare_part_categories#index'
        get    '/spare_part_categories/select',            to: 'spare_part_categories#index_select'
        get    '/spare_part_categories/:id',               to: 'spare_part_categories#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/spare_part_categories',                   to: 'spare_part_categories#create'
        put    '/spare_part_categories/:id',               to: 'spare_part_categories#update'
        patch  '/spare_part_categories/:id',               to: 'spare_part_categories#update'
        delete '/spare_part_categories/:id',               to: 'spare_part_categories#destroy'

        ####################### Repuestos ##############################
        get    '/spare_parts',                             to: 'spare_parts#index'
        get    '/spare_parts/:id',                         to: 'spare_parts#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/spare_parts',                             to: 'spare_parts#create'
        put    '/spare_parts/:id',                         to: 'spare_parts#update'
        patch  '/spare_parts/:id',                         to: 'spare_parts#update'
        delete '/spare_parts/:id',                         to: 'spare_parts#destroy'

        ####################### Especificaciones de Repuestos ##############################
        get    '/spare_part_specs',                        to: 'spare_part_specs#index'
        get    '/spare_part_specs/:id',                    to: 'spare_part_specs#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/spare_part_specs',                        to: 'spare_part_specs#create'
        put    '/spare_part_specs/:id',                    to: 'spare_part_specs#update'
        patch  '/spare_part_specs/:id',                    to: 'spare_part_specs#update'
        delete '/spare_part_specs/:id',                    to: 'spare_part_specs#destroy'

        # Rutas anidadas para especificaciones
        get    '/spare_parts/:spare_part_id/specs',        to: 'spare_part_specs#index_by_spare_part'
        post   '/spare_parts/:spare_part_id/specs/bulk_create', to: 'spare_part_specs#bulk_create'
        delete '/spare_parts/:spare_part_id/specs/bulk_destroy', to: 'spare_part_specs#bulk_destroy'

        ####################### Compatibilidades de Repuestos ##############################
        get    '/spare_part_compatibilities',              to: 'spare_part_compatibilities#index'
        get    '/spare_part_compatibilities/:id',          to: 'spare_part_compatibilities#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        delete '/spare_part_compatibilities/:id',          to: 'spare_part_compatibilities#destroy'

        # Rutas anidadas para compatibilidades
        get    '/spare_parts/:spare_part_id/compatibilities', to: 'spare_part_compatibilities#index_by_spare_part'
        post   '/spare_parts/:spare_part_id/compatibilities', to: 'spare_part_compatibilities#create'
        post   '/spare_parts/:spare_part_id/compatibilities/bulk_create', to: 'spare_part_compatibilities#bulk_create'

        ####################### Proveedores ##############################
        get    '/suppliers',                   to: 'suppliers#index'
        get    '/suppliers/select',            to: 'suppliers#index_select'
        get    '/suppliers/:id',               to: 'suppliers#show'
        post   '/suppliers',                   to: 'suppliers#create'
        put    '/suppliers/:id',               to: 'suppliers#update'
        patch  '/suppliers/:id',               to: 'suppliers#update'
        delete '/suppliers/:id',               to: 'suppliers#destroy'
        ####################### Gestión de Productos por Proveedor ##############################
        get    '/supplier_products',                   to: 'supplier_products#index'
        get    '/supplier_products/select',            to: 'supplier_products#index_select'
        get    '/supplier_products/:id',               to: 'supplier_products#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/supplier_products',                   to: 'supplier_products#create'
        put    '/supplier_products/:id',               to: 'supplier_products#update'
        patch  '/supplier_products/:id',               to: 'supplier_products#update'
        delete '/supplier_products/:id',               to: 'supplier_products#destroy'

        # Rutas anidadas 
        get    '/suppliers/:supplier_id/supplier_products', to: 'supplier_products#index_by_supplier'
        get    '/products/:product_id/supplier_products',   to: 'supplier_products#index_by_product'

        ####################### Órdenes de Compra ##############################
        get    '/purchase_orders',                   to: 'purchase_orders#index'
        get    '/purchase_orders/select',            to: 'purchase_orders#index_select'
        get    '/purchase_orders/:id',               to: 'purchase_orders#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/purchase_orders',                   to: 'purchase_orders#create'
        put    '/purchase_orders/:id',               to: 'purchase_orders#update'
        patch  '/purchase_orders/:id',               to: 'purchase_orders#update'
        delete '/purchase_orders/:id',               to: 'purchase_orders#destroy'
        put    '/purchase_orders/:id/receive',       to: 'purchase_orders#receive'
        put    '/purchase_orders/:id/cancel',        to: 'purchase_orders#cancel' 
        get    '/purchase_orders/by_supplier/:supplier_id', to: 'purchase_orders#by_supplier'

        ####################### Ítems de Orden de Compra ##############################
        get    '/purchase_order_items',                   to: 'purchase_order_items#index'
        get    '/purchase_order_items/:id',               to: 'purchase_order_items#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        post   '/purchase_order_items',                   to: 'purchase_order_items#create'
        put    '/purchase_order_items/:id',               to: 'purchase_order_items#update'
        patch  '/purchase_order_items/:id',               to: 'purchase_order_items#update'
        delete '/purchase_order_items/:id',               to: 'purchase_order_items#destroy'

        # Rutas anidadas
        get    '/purchase_orders/:purchase_order_id/items', to: 'purchase_order_items#index_by_order'
        post   '/purchase_orders/:purchase_order_id/items/bulk_create', to: 'purchase_order_items#bulk_create'

      end
    end
  end
end