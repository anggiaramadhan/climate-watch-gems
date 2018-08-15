HistoricalEmissions::Engine.routes.draw do
  resources :emissions, only: [:index], controller: :historical_emissions do
    get :meta, on: :collection
  end
end
