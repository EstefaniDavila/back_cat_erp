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
      end
    end
  end
end
