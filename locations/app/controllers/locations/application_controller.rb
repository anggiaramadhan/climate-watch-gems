module Locations
  class ApplicationController < ActionController::API
    include ::ClimateWatchEngine::Caching
    include ::ClimateWatchEngine::Cors
    include ::ClimateWatchEngine::ExceptionResponses
  end
end
