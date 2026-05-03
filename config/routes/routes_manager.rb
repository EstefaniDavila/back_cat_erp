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
      end
    end
  end
end
