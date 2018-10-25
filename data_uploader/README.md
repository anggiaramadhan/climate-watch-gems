# DataUploader
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
git 'https://github.com/ClimateWatch-Vizzuality/climate-watch-gems.git' do
  gem 'cw_data_uploader', '~> 0.1.0', require: 'data_uploader'
end
```

If you want to use a checked out version of the gem locally add this instead:

```
# for debugging
gem 'cw_data_uploader', '~> 0.1.1', require: 'data_uploader', path: '../climate-watch-gems'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install cw_data_uploader
```

## Setting up

Create an initializer, setting the app name:

```
# DataUploader engine initializer
require 'data_uploader'

DataUploader.app_name = 'global_cw_platform'
```

Create a configuration file in config/data_uploader.yml with this structure:

```
platforms:
  - name: global_country_platform
    sections:
      - name: new_adaptation
        worker: ImportAdaptationWorker
        datasets:
          - adaptation
          - adaptation_metadata
```

Generate Active Admin controllers:

`bundle exec rake data_uploader:generate`

Install & run migrations:

`bundle exec rake data_uploader:install:migrations`
`bundle exec rake db:migrate`

Populate database with boilerplate objects:

`bundle exec rake db:admin_boilerplate:create`

Note: This task can be called multiple times without creating duplicates; it also deletes obsolete boilerplate objects in order to keep them in sync with `config/data_uploader.yml`. If you need to start again, to clear the boilerplate objects:

`bundle exec rake db:admin_boilerplate:clear_all`

Configure environment variables:

- `aws_region`: _The AWS region where the files to import are located._ Defined in the file `secrets.yml`
- `CW_FILES_PREFIX`: _The location of the files to import._ Defined in the `.env` file (defaults to `climate-watch-datasets/`)
- `CW_FILES_PREFIX_TEST`: defined in the `.env` file (defaults to `test/`)
- `REDIS_SERVER`: _Redis Server._ Defined in the `.env` file (defaults to `redis://localhost:6379/0`)
- `MAIL_SENDER`: _The email sender for the password recovery._ Defined in the `.env` file (defaults to `password@example.com`)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
