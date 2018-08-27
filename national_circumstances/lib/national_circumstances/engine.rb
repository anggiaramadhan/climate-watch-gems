module NationalCircumstances
  class Engine < ::Rails::Engine
    isolate_namespace NationalCircumstances
    config.generators.api_only = true
  end
end
