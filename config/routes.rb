Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :items do
        get '/find_all', to: 'search#index'
      end
      namespace :merchants do
        get '/find', to: 'search#show'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
      resources :items, only: [:index]
    end
  end
end
