Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :manager do
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
        get '/advisors',                                      to: 'leads#advisors'

        ####################### QUOTATIONS #########################
        get '/quotations',                                    to: 'quotations#index'
        get '/quotations/:code',                              to: 'quotations#show'
        put '/quotations/:id/approve',                        to: 'quotations#approve'
        put '/quotations/:id/final_approve',                   to: 'quotations#final_approve'
        put '/quotations/:id/reject',                         to: 'quotations#reject'
        put '/quotations/:id/client_accept',                  to: 'quotations#client_accept'
        put '/quotations/:id',                                to: 'quotations#update'

        ####################### AREA REQUESTS ######################
        get '/area_requests',                                 to: 'area_requests#index'
        get '/area_requests/:id',                             to: 'area_requests#show'
        post '/area_requests',                                to: 'area_requests#create'

        ####################### MAINTENANCES ######################
        get '/maintenances',                                  to: 'maintenances#index'
        post '/maintenances',                                 to: 'maintenances#create'
        put '/maintenances/:id',                              to: 'maintenances#update'
        delete '/maintenances/:id',                           to: 'maintenances#destroy'
        patch '/maintenances/update_status/:id',              to: 'maintenances#update_status'

        ####################### WORK ORDERS ######################
        get '/work_orders',                                   to: 'work_orders#index'
        post '/work_orders',                                  to: 'work_orders#create'
        put '/work_orders/:id',                               to: 'work_orders#update'
        delete '/work_orders/:id',                            to: 'work_orders#destroy'
        get '/work_orders/maintenance/:maintenance_id',       to: 'work_orders#index_by_maintenance'
        get '/work_orders/technician/:technician_id',         to: 'work_orders#index_by_technician'
        patch '/work_orders/update_diagnosis/:id',            to: 'work_orders#update_diagnosis'
        patch '/work_orders/update_status/:id',               to: 'work_orders#update_status'
        get '/work_orders/calendar/:technician_id',           to: 'work_orders#calendar_by_technician'

        ####################### WORK ORDER ACTIONS ######################
        get '/work_order_actions',                            to: 'work_order_actions#index'
        post '/work_order_actions',                           to: 'work_order_actions#create'
        put '/work_order_actions/:id',                        to: 'work_order_actions#update'
        delete '/work_order_actions/:id',                     to: 'work_order_actions#destroy'
        get '/work_order_actions/work_order/:work_order_id',  to: 'work_order_actions#index_by_work_order'

        ####################### WORK ORDER PARTS ######################
        get '/work_order_parts',                              to: 'work_order_parts#index'
        post '/work_order_parts',                             to: 'work_order_parts#create'
        put '/work_order_parts/:id',                          to: 'work_order_parts#update'
        delete '/work_order_parts/:id',                       to: 'work_order_parts#destroy'

        ####################### TECHNICIANS ######################
        get '/technicians',                                   to: 'technicians#index'
        get '/technicians/list',                              to: 'technicians#list'
        # post '/technicians',                                  to: 'technicians#create'
        # put '/technicians/:id',                               to: 'technicians#update'
        # delete '/technicians/:id',                            to: 'technicians#destroy'
        
        ####################### RENTALS ######################
        get '/rentals',                                   to: 'rentals#index'
        post '/rentals',                                  to: 'rentals#create'
        put '/rentals/:id',                               to: 'rentals#update'
        delete '/rentals/:id',                            to: 'rentals#destroy'
      end
    end
  end
end
