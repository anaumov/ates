Rails.application.routes.draw do
  devise_for :users, class_name: 'Account', controllers: {
    omniauth_callbacks: 'omniauth_callbacks'
  }

  root "dashboard#index"
end
