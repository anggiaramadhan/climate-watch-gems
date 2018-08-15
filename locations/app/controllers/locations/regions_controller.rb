module Locations
  class RegionsController < ApplicationController
    def index
      regions = Location.where(
        location_type: %w(REGION GROUP),
        show_in_cw: true
      ).includes(:members).order(:wri_standard_name)

      render json: regions,
             each_serializer: LocationSerializer,
             topojson: params.key?(:topojson)
    end
  end
end
