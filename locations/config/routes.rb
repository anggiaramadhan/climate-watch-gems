Locations::Engine.routes.draw do
  #namespace :locations do
    resources :countries, only: [:index]
    resources :regions, only: [:index]
  #end
end
