$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'locations/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'cw_locations'
  s.version     = Locations::VERSION
  s.authors     = ['Agnieszka Figiel']
  s.email       = ['agnieszka.figiel@vizzuality.com']
  s.homepage    = 'https://www.climatewatchdata.org'
  s.summary     = 'Climate Watch -> Locations'
  s.description = 'Climate Watch -> Locations'

  s.required_ruby_version     = ">= 2.4.1"
  s.required_rubygems_version = ">= 1.8.11"

  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'active_model_serializers', '~> 0.10.0'
  s.add_dependency 'aws-sdk', '~> 2'
  s.add_dependency 'climate_watch_engine', '~> 1.0.0'
  s.add_dependency 'rails', '~> 5.1.5'
  s.add_dependency 'pg'

  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'rspec-rails'

  s.test_files = Dir['spec/**/*']
end
