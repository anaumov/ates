Rails.application.routes.draw do
  devise_for :accounts, controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "tasks#index"
end
