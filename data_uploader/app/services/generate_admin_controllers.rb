require 'erb'

module DataUploader
  class GenerateAdminControllers
    def call
      generate_controllers(YAML.load_file(FILE_TO_IMPORT))
    end

    private

    def generate_controllers(content)
      content['platforms'].each do |platform|
        platform['sectors'].each do |sector|
          @platform = platform
          @sector = sector
          folder = Rails.root + 'admin'
          FileUtils.mkdir_p(folder) unless File.directory?(folder)
          parsed_template = ERB.new(File.read('./admin_controller_template.rb.erb'))
          File.open(folder + '/' + sector.underscore + '.rb', 'w') do |f|
            f.write(parsed_template)
          end
        end
      end
    end
  end
end
