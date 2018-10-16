namespace :db do
  desc 'Creates datasets for sections for admin panel'
  task datasets_create: :environment do
    config = YAML.load_file(FILE_TO_IMPORT)
    config['platforms'].each do |platform_props|
      platform = DataUploader::Platform.find_by(name: platform_props['name'])
      next unless platform
      platform_props['sections'].each do |section_props|
        section = platform.sections.find_by(name: section_props['name'])
        next unless section
        section_props['datasets'].each do |dataset|
          DataUploader::Dataset.create(name: dataset, section: section)
          puts "Dataset #{dataset} for section #{section.name} created."
        end
      end
    end
  end
end
