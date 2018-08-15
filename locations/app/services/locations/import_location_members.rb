module Locations
  class ImportLocationMembers
    def call
      import_records(S3CSVReader.read(Locations.location_groupings_filepath))
    end

    private

    # rubocop:disable Lint/RedundantWithIndex
    def import_records(content)
      content.each.with_index(2) do |row|
        iso_code3 = iso_code3(row)
        parent_iso_code3 = parent_iso_code3(row)
        member = iso_code3 && Location.find_by_iso_code3(iso_code3)
        location = parent_iso_code3 &&
          Location.find_by_iso_code3(parent_iso_code3)
        if location && member
          LocationMember.find_or_create_by(
            location_id: location.id, member_id: member.id
          )
        else
          Rails.logger.warn "Unable to create member #{row}"
        end
      end
    end
    # rubocop:enable Lint/RedundantWithIndex

    def iso_code3(row)
      row[:iso_code3] && row[:iso_code3].upcase
    end

    def parent_iso_code3(row)
      row[:parent_iso_code3] && row[:parent_iso_code3].upcase
    end
  end
end
