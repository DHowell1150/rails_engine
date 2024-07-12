Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/items/find_all', to: 'items#find_all'
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get '/merchant', to: 'items_merchant#index', as: :merchant
      end

      get '/merchants/find', to: 'merchants#find'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
    end
  end
end
