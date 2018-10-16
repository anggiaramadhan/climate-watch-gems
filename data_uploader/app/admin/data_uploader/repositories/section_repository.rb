module DataUploader
  module Repositories
    class SectionRepository
      def filter_by_section_name(section_name)
        DataUploader::Section.where(name: section_name)
      end

      def filter_sections_by_platform(sections, platform_id)
        sections.find_by(platform_id: platform_id)
      end

      def filter_by_section_and_platform(section_name, platform_name)
        DataUploader::Section.
          where(name: section_name).
          find_by(platform_id: DataUploader::Platform.find_by(name: platform_name).id)
      end
    end
  end
end
