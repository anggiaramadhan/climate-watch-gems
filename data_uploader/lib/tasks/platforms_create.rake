namespace :db do
  desc 'Creates platforms for admin panel'
  task platforms_create: :environment do
    config = YAML.load_file(FILE_TO_IMPORT)
    platform_names = config['platforms'].map { |p| p['name'] }
    platform_names.each do |platform_name|
      Admin::Platform.create(name: platform_name)
    end
    puts 'Platforms for admin panel created'
  end
end
