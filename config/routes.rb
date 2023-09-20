Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post '/login', to: 'session#create'
      resources :users, only: [:create]
      resources :products, only: [:index, :show, :create, :update, :destroy] do
        get :category_options, path: '/category-options', on: :collection
        get :price_options, path: '/price-options', on: :collection
        get :list, on: :collection
      end
    end
  end
end
