namespace :db do
  namespace :platforms do
    desc 'Creates platforms for admin panel'
    task create: :clear_obsolete do
      config = YAML.load_file(FILE_TO_IMPORT)
      cnt = 0

      platform_names = config['platforms'].map { |p| p['name'] }
      platform_names.each do |platform_name|
        next if DataUploader::Platform.find_by(name: platform_name)

        DataUploader::Platform.create(name: platform_name)
        cnt += 1
      end

      puts "#{cnt} platforms created"
    end

    task clear_obsolete: 'db:sections:clear_obsolete' do
      old_names = DataUploader::Platform.pluck(:name).to_set
      config = YAML.load_file(FILE_TO_IMPORT)
      new_names = config['platforms'].map { |p| p['name'] }
      new_names.each { |name| old_names.delete(name) }
      puts "Removing obsolete platforms: #{old_names.to_a.join(',')}"
      DataUploader::Platform.where(name: old_names.to_a).destroy_all
    end

    task clear_all: 'db:sections:clear_all' do
      DataUploader::Platform.destroy_all
    end
  end
end
