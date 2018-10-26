require 'active_admin'
require 'devise'
require 'aws-sdk-rails'
require 'aws-sdk-s3'
require 'sidekiq'

module DataUploader
  class Engine < ::Rails::Engine
    isolate_namespace DataUploader

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end
