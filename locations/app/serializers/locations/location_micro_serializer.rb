module Locations
  class LocationMicroSerializer < ActiveModel::Serializer
    attributes :iso_code3,
               :wri_standard_name,
               :centroid

    has_many :members,
             serializer: LocationNanoSerializer

    attribute :topojson, if: -> { instance_options[:topojson] }
  end
end
