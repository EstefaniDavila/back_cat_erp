Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :logistic_user do
        get '/suppliers', to: 'suppliers#index'
        get '/suppliers/select', to: 'suppliers#index_select'
        get '/suppliers/:id', to: 'suppliers#show'

        # Ordén de Compra a Proveedores

        post '/purchase_orders', to: 'purchase_orders#create'
        get  '/purchase_orders', to: 'purchase_orders#index'

        #Items para la orden de comopra

        get    '/purchase_order_items',                   to: 'purchase_order_items#index'
        get    '/purchase_order_items/:id',               to: 'purchase_order_items#show'
        get    '/purchase_orders/:purchase_order_id/items', to: 'purchase_order_items#index_by_order'
        post   '/purchase_order_items',                   to: 'purchase_order_items#create'
        put    '/purchase_order_items/:id',               to: 'purchase_order_items#update'
        patch  '/purchase_order_items/:id',               to: 'purchase_order_items#update'
        delete '/purchase_order_items/:id',               to: 'purchase_order_items#destroy'
        post   '/purchase_orders/:purchase_order_id/items/bulk_create', to: 'purchase_order_items#bulk_create'

        #Productos

        get '/products',        to: 'products#index'
        get '/products/search', to: 'products#search'
        get '/products/:id',    to: 'products#show'

      end
    end
  end
end