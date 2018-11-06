module Locations
  class LocationsController < ApplicationController
    def index
      unless params[:location_type] && Location::LOCATION_TYPES.include?(params[:location_type])
        render json: {
          status: :bad_request,
          error: "Please specify `location_type` (#{Location::LOCATION_TYPES.join(', ')})"
        }, status: :bad_request and return
      end

      locations = Location.where(
        location_type: params[:location_type],
        show_in_cw: true
      ).includes(:members).order(:wri_standard_name)

      render json: locations,
             each_serializer: LocationMicroSerializer,
             topojson: params.key?(:topojson)
    end
  end
end