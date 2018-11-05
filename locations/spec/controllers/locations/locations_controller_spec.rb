require 'rails_helper'

describe Locations::LocationsController, type: :controller do
  routes { Locations::Engine.routes }

  context do
    let!(:some_locations) {
      FactoryBot.create_list(:location_country, 3)
    }

    describe 'GET index' do
      it 'returns a bad request when no location_type' do
        get :index
        expect(response).to be_bad_request
      end

      it 'returns a successful 200 response' do
        get :index, params: {location_type: 'COUNTRY'}
        expect(response).to be_successful
      end

      it 'lists all known locations that are countries' do
        get :index, params: {location_type: 'COUNTRY'}
        parsed_body = JSON.parse(response.body)
        expect(parsed_body.length).to eq(3)
      end
    end
  end
end
