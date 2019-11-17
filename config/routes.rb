Rails.application.routes.draw do
  # Standard users
  # We provide our own rolled routes for user
  # endpoints; users should only be communicating
  # with rails via json api communication
  # devise_for :users
  post '/users/new', to: 'users#new'
  post '/users/login', to: 'users#login'
  get '/users/me', to: 'users#info'

  get '/members', to: 'members#index'
  get '/members/:member_id', to: 'members#show'

  get '/topics', to: 'topics#index'
  get '/topics/:topic_id', to: 'topics#show'
  post '/topics', to: 'topics#search'

  # Administrators who have access to /admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
