module Locations
  class CountriesController < ApplicationController
    def index
      countries = Location.where(
        location_type: 'COUNTRY',
        show_in_cw: true
      ).order(:wri_standard_name)

      render json: countries,
             each_serializer: LocationSerializer,
             topojson: params.key?(:topojson)
    end
  end
end
