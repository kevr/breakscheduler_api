Rails.application.routes.draw do
  # Standard users
  # We provide our own rolled routes for user
  # endpoints; users should only be communicating
  # with rails via json api communication
  # devise_for :users

  # Administrators who have access to /admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
