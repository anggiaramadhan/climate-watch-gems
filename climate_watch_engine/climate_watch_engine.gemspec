$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'climate_watch_engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'climate_watch_engine'
  s.version     = ClimateWatchEngine::VERSION
  s.authors     = ['Agnieszka Figiel']
  s.email       = ['agnieszka.figiel@vizzuality.com']
  s.homepage    = 'https://www.climatewatchdata.org'
  s.summary     = 'Climate Watch generic engine'
  s.description = 'Climate Watch generic engine'

  s.required_ruby_version     = ">= 2.5.1"
  s.required_rubygems_version = ">= 1.8.11"

  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'aws-sdk', '~> 2'
  s.add_dependency 'rails', '~> 5.2.0'
end
