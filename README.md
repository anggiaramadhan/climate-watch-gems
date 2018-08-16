# climate-watch-gems
Climate Watch gems to reuse in country platforms.

## General idea

In order to allow reusing backend (Rails) code of ClimateWatch Global in country platforms, or share code between country platforms, we package any such code as a "Rails engine gem". We use this repository to store all such gems and ClimateWatch platforms pull this code by requiring the relevant gems using bundler.

## What is an engine?

An engine is a gem, which means it can be loaded into an application in a familiar way using the Gemfile. However, it is a Rails-specific gem, whose organisation follows the same structure as a Rails application - MVC, database migrations, rake tasks, specs can all be packaged in an engine and, most importantly, "mounted", or plugged into, a host Rails application.

## How is an engine useful for sharing code across Climate Watch platforms?

The backend code in Climate Watch is organised more or less "by dataset". For each dataset we typically have:
- database migrations
- models
- services - importers
- controllers - endpoints
- serializers
- specs
- rake tasks

If the same TYPE of dataset needs to be incorporated in more than one Climate Watch platform, we need to share this code between more than one application. An engine is ideal to package these different kinds of obects that all pertain to a single dataset.

## How to incorporate an engine in the host application?

We aim for all engines listed here to be handled very similarly, so these generic steps apply:

- add it to the Gemfile. Currently we use this repository to serve gems (we don't publish to rubygems), which is why we need to use the `git:` parameter to point to the repo. Some gems have a different gem name than the actual name of the engine; that is because by having a shared prefix it is a bit easier to spot them among external gems in the Gemfile.

```
git 'https://github.com/ClimateWatch-Vizzuality/climate-watch-gems.git' do
  gem 'climate_watch_engine', '~> 1.0'
  gem 'cw_locations', '~> 1.0', require: 'locations'
  gem 'cw_historical_emissions', '~> 1.0', require: 'historical_emissions'
end
```

- if the engine exposes configurable attributes (most do), set them in the initializer, e.g. `config/initializers/climate_watch_engine.rb`:

`ClimateWatchEngine.s3_bucket_name = Rails.application.secrets.s3_bucket_name`

- if the engine contains API endpoints (most do), mount the routes in config/routes.rb:

`mount HistoricalEmissions::Engine => 'api/v1'`

- if the engine contains database migrations (most do), run this task to copy them over to the migrations directory:

`rake your_engine_name:install:migrations`

- if the engine contains rake tasks (you get it now), tasks are automatically visible to the host application.

## How to extract existing code into an engine?

Have a look at examples in this repository and recommended reading below.

## How to write a new engine?

In the first place ask yourself if the functionality you're implementing needs to be reusable, because maybe there's no need to go the engine route. When unsure, you can always extract later. In order to be able to do that easily, take care to namespace the code and avoid coupling.

Useful tip: you can start working on an engine locally within the host application, and add it to the Gemfile using the `path:` parameter; this makes it easier to work with while under active development.

Refer to the Rails guide and double check the following:
- all dependencies listed in the gemspec
- ruby version specified in the gemspec and the Gemfile
- do not check in Gemfile.lock
- anything peculiar about installation of the engine is documented

## How to configure / amend an engine within the host application?

Two techniques stand out:
- using decorators to extend engine's classes in host application
- using engine attributes to allow configuration through initialiser

Both are described in the Rails guide.

## How to make changes to the engine?

Once the engine is integrated into a host application, every change to it must bump the version.

- PATCH 0.0.x level changes for implementation level detail changes, such as small bug fixes
- MINOR 0.x.0 level changes for any backwards compatible API changes, such as new functionality/features
- MAJOR x.0.0 level changes for backwards incompatible API changes, such as changes that will break existing users code if they update

## Recommended reading

To learn about engines start with the [Rails guide](https://guides.rubyonrails.org/engines.html). However, I found these additional resources provided invaluable practical information:
- [Rails 5 engines + RSpec + FactoryBot](https://medium.com/@mohnishgj/how-to-setup-rspec-factory-bot-and-spring-for-a-rails-5-engines-154af307c12d)
- [Differences between gems, plugins, railties and engines](http://hawkins.io/2012/03/defining_plugins_gems_railties_and_engines/)
- [Serving gems directly from git repositories](https://bundler.io/v1.12/git.html)
- [Gemspec vs Gemfile](https://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/)
