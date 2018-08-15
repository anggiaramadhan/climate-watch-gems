$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'historical_emissions/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'cw_historical_emissions'
  s.version     = HistoricalEmissions::VERSION
  s.authors     = ['Agnieszka Figiel']
  s.email       = ['agnieszka.figiel@vizzuality.com']
  s.homepage    = 'https://www.climatewatchdata.org'
  s.summary     = 'Climate Watch -> GHG Historical Emissions.'
  s.description = 'Climate Watch -> GHG Historical Emissions.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'active_model_serializers', '~> 0.10.0'
  s.add_dependency 'aws-sdk', '~> 2'
  s.add_dependency 'climate_watch_engine'
  s.add_dependency 'cw_locations'
  s.add_dependency 'pg'
  s.add_dependency 'rails', '~> 5.1.5'

  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'rspec-rails'

  s.test_files = Dir['spec/**/*']
end
