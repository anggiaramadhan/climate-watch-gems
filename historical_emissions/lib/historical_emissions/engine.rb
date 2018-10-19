require 'active_model_serializers'
require 'aws-sdk-s3'
require 'locations/engine'

module HistoricalEmissions
  class Engine < ::Rails::Engine
    isolate_namespace HistoricalEmissions

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end
