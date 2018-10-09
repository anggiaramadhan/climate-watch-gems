Rails.application.routes.draw do
  mount HistoricalEmissions::Engine => "/historical_emissions"
end
