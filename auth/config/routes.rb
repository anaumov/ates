Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, class_name: 'Account'

  resources :accounts do
    get :current, on: :collection
  end

  root "accounts#index"
end
