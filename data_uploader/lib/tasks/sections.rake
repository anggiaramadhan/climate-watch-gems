namespace :db do
  namespace :sections do
    desc 'Creates sections for admin panel'
    task create: :clear_obsolete do
      config = YAML.load_file(FILE_TO_IMPORT)
      cnt = 0

      config['platforms'].each do |platform_props|
        platform = DataUploader::Platform.find_by(name: platform_props['name'])
        next unless platform

        section_names = platform_props['sections'].map { |s| s['name'] }
        section_names.each do |section_name|
          next if DataUploader::Section.find_by(name: section_name)

          DataUploader::Section.create(name: section_name, platform: platform)
          cnt += 1
        end
      end

      puts "#{cnt} sections created"
    end

    task clear_obsolete: 'db:datasets:clear_obsolete' do
      old_names = Hash[
        DataUploader::Platform.includes(:sections).map do |p|
          [p.name, p.sections.pluck(:name)]
        end
      ]
      config = YAML.load_file(FILE_TO_IMPORT)
      config['platforms'].each do |platform_props|
        platform_name = platform_props['name']
        next unless old_names[platform_name]

        platform_props['sections'].each do |section_props|
          section_name = section_props['name']
          next unless old_names[platform_name].find(section_name)

          old_names[platform_name].delete(section_name)
        end
        sections = DataUploader::Section.
          joins(:platform).
          where(
            'platforms.name' => platform_name,
            name: old_names[platform_name]
          )
        next unless sections.any?
        puts "[Platform: #{platform_name}] Removings obsolete sections:"
        sections.each { |s| puts s.name; s.destroy }
      end
    end

    task clear_all: 'db:datasets:clear_all' do
      DataUploader::Section.destroy_all
    end
  end
end
