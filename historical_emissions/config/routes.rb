HistoricalEmissions::Engine.routes.draw do
  resources :emissions,
            only: [:index],
            controller: :historical_emissions,
            defaults: { format: 'json' } do
    get :meta, on: :collection
  end
end
