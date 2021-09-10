Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      namespace :items do
        get '/find_all', to: 'search#index'
        get '/find_all', to: 'search#index'
      end

      namespace :merchants do
        get '/find',       to: 'search#show'
        get '/most_items', to: 'search#index'
        get ':merchant_id/items',      to: 'items#index'
      end

      resources :merchants, only: [:index, :show]

      resources :items, only: [:index, :show, :create]

      namespace :revenue do
        get '/merchants',     to: 'search_merchant#index'
        get '/merchants/:id', to: 'search_merchant#show'
        get '/items',         to: 'search_item#index'
      end
    end
  end
end
