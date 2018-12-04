module Locations
  class ImportLocationMembers
    include ClimateWatchEngine::CSVImporter

    headers :iso_code3, :parent_iso_code3

    def call
      return unless valid_headers?(csv, Locations.location_groupings_filepath, headers)

      ActiveRecord::Base.transaction do
        import_records
      end
    end

    private

    def csv
      @csv ||= S3CSVReader.read(Locations.location_groupings_filepath)
    end

    def import_records
      import_each_with_logging(csv, Locations.location_groupings_filepath) do |row|
        LocationMember.find_or_create_by!(
          location: Location.find_by_iso_code3(row[:iso_code3]&.upcase),
          member: Location.find_by_iso_code3(row[:parent_iso_code3]&.upcase)
        )
      end
    end
  end
end
