Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :advisor do
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

        ####################### QUOTATIONS #########################
        get '/quotations',                                    to: 'quotations#index'
        get '/quotations/:code',                              to: 'quotations#show'
        post '/quotations',                                   to: 'quotations#create'
        put '/quotations/:id',                                to: 'quotations#update'
        put '/quotations/:id/send_for_approval',              to: 'quotations#send_for_approval'

        ####################### AREA REQUESTS ######################
        get '/area_requests',                                 to: 'area_requests#index'
        post '/area_requests',                                to: 'area_requests#create'
      end
    end
  end
end
