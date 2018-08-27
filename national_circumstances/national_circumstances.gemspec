$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "national_circumstances/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "national_circumstances"
  s.version     = NationalCircumstances::VERSION
  s.authors     = ["Tiago Santos"]
  s.email       = ["santos.tiago@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of NationalCircumstances."
  s.description = "TODO: Description of NationalCircumstances."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "pg"
end
