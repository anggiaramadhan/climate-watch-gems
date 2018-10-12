# DataUploader
Short description and motivation.

## Usage
How to use my plugin.

## Setting up

# Environment variable

- `aws_region`: _The AWS region where the files to import are located._ Defined in the file `secrets.yml`
- `CW_FILES_PREFIX`: _The location of the files to import._ Defined in the `.env` file (defaults to `climate-watch-datasets/`)
- `CW_FILES_PREFIX_TEST`: defined in the `.env` file (defaults to `test/`)
- `REDIS_SERVER`: _Redis Server._ Defined in the `.env` file (defaults to `redis://localhost:6379/0`)
- `MAIL_SENDER`: _The email sender for the password recovery._ Defined in the `.env` file (defaults to `password@example.com`)

# Configuration file

`initializers/data_uploader.yaml` example

```
platforms:
  name: platform1
  sections:
    name: section1
    importers:
      name: importer1
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'data_uploader'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install data_uploader
```

Generate Active Admin controllers:

`bundle exec rake data_uploader:generate`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
