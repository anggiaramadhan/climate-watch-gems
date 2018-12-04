module Locations
  class ImportLocations
    include ClimateWatchEngine::CSVImporter

    headers :pik_name, :cait_name, :wri_standard_name, :iso_code3, :iso_code2,
            :unfccc_group, :location_type, :show_in_cw

    def call
      return unless valid_headers?(csv, Locations.locations_filepath, headers)

      ActiveRecord::Base.transaction do
        import_locations
        import_topojson
      end
    end

    private

    def csv
      @csv = S3CSVReader.read(Locations.locations_filepath)
    end

    def import_locations
      import_each_with_logging(csv, Locations.locations_filepath) do |row|
        attributes = {
          iso_code3: iso_code3(row),
          iso_code2: iso_code2(row),
          wri_standard_name: row[:wri_standard_name],
          pik_name: row[:pik_name],
          cait_name: row[:cait_name],
          ndcp_navigators_name: row[:ndcp_navigators_name],
          unfccc_group: row[:unfccc_group],
          location_type: row[:location_type] || 'COUNTRY',
          show_in_cw: show_in_cw(row)
        }

        create_or_update(attributes)
      end
    end

    def import_topojson
      uri = URI(Locations.cartodb_url)
      response = Net::HTTP.get(uri)
      parsed_response = JSON.parse(response, symbolize_names: true)
      parsed_response[:rows].each do |row|
        centroid = row[:centroid].nil? ? {} : JSON.parse(row[:centroid])
        begin
          Location.
            where(iso_code3: row[:iso]).
            update(topojson: JSON.parse(row[:topojson]), centroid: centroid)
        rescue JSON::ParserError => e
          msg = "Error importing topojson data for #{row[:iso]}: #{e}"
          STDERR.puts msg
          add_error(
            :topojson,
            msg: msg
          )
        end
      end
    end

    def iso_code3(row)
      row[:iso_code3] && row[:iso_code3].upcase
    end

    def iso_code2(row)
      if row[:iso_code2].blank?
        ''
      else
        row[:iso_code2] && row[:iso_code2].upcase
      end
    end

    def show_in_cw(row)
      if row[:show_in_cw].blank?
        true
      else
        row[:show_in_cw].match?(/no/i) ? false : true
      end
    end

    def create_or_update(attributes)
      iso_code3 = attributes[:iso_code3]
      location = Location.find_or_initialize_by(iso_code3: iso_code3)
      location.assign_attributes(attributes)

      op = location.new_record? ? 'CREATE' : 'UPDATE'

      if location.save
        Rails.logger.debug "#{op} OK #{iso_code3}"
      else
        Rails.logger.error "#{op} FAILED #{iso_code3}"
      end
    end
  end
end
