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


      end
    end
  end
end