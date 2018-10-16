namespace :db do
  desc 'Creates sections for admin panel'
  task sections_create: :environment do
    config = YAML.load_file(FILE_TO_IMPORT)

    config['platforms'].each do |platform_props|
      platform = Admin::Platform.find_by(name: platform_props['name'])
      next unless platform

      platform_props['sections'].each do |section_props|
        Admin::Section.create(
          name: section_props['name'], platform: platform
        )
      end
    end

    puts 'Platforms and sections for admin panel created'
  end
end
