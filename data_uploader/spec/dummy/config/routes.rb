Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  authenticate :admin_user do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
