Rails.application.routes.draw do
  use_doorkeeper
  devise_for :accounts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :accounts, only: %w[show index edit update] do
    get :current, on: :collection
  end
end
