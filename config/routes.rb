Rails.application.routes.draw do
  post '/users/admin/login', to: 'users#admin_login'

  post '/users/new', to: 'users#new'
  post '/users/login', to: 'users#login'
  get '/users/me', to: 'users#info'

  get '/members', to: 'members#index'
  get '/members/:member_id', to: 'members#show'

  get '/topics', to: 'topics#index'
  get '/topics/:topic_id', to: 'topics#show'
  post '/topics', to: 'topics#search'

  get '/articles', to: 'articles#index'
  get '/articles/:article_id', to: 'articles#show'

  # Administrators who have access to /admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
