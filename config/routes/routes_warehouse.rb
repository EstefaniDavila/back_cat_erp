Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :warehouse do
        
        # Ver productos
        get '/products', to: 'products#index'
        get '/products/:id', to: 'products#show', constraints: { id: /[0-9a-fA-F\-]{36}/ }
        
        # Editar productos
        patch '/products/:id/update_stock', to: 'products#update_stock'
        patch '/products/:id/update_price', to: 'products#update_price'
        
        # Reportes y búsquedas
        get '/products/search', to: 'products#search'
        get '/products/low_stock', to: 'products#low_stock'
        get '/products/critical_stock', to: 'products#critical_stock'
        
      end
    end
  end
end