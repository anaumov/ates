Rails.application.routes.draw do
  devise_for :accounts, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  resources :tasks do
    post :reshuffle, on: :collection
    post :complete, on: :member
  end

  root "tasks#index"
end
