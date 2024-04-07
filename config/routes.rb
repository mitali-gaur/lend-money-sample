require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  root to: 'home#dashboard'

  resources :loans, only: [:new, :create] do
    member do
      put :accept_confirmation_request
      put :reject_confirmation_request
      put :repay
    end
  end

  devise_scope :admin_user do
    authenticated :admin_user do
      mount Sidekiq::Web => "/sidekiq"
    end
  end
end
