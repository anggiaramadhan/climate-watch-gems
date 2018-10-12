require 'erb'

module DataUploader
  class GenerateAdminControllers
    def call
      generate_controllers(YAML.load_file(FILE_TO_IMPORT))
    end

    private

    def generate_controllers(content)
      content['platforms'].each do |platform|
        @platform = platform['name']
        raise 'Platform missing' unless @platform
        @menu = platform['display_name'] || @platform.titleize
        platform['sections'].each do |section|
          @section = section['name']
          raise 'Section missing' unless @section
          @worker = section['importer']
          next unless @worker.present?
          folder = Rails.root + 'app/admin/' + @platform
          FileUtils.mkdir_p(folder) unless File.directory?(folder)
          parsed_template = ERB.new(
            File.read(
              File.expand_path(
                '../../templates/admin_controller_template.rb.erb',
                __FILE__
              )
            )
          )
          File.open(File.join(folder, @section.underscore + '.rb'), 'w') do |f|
            f.write(parsed_template.result(binding))
          end
        end
      end
    end
  end
end
