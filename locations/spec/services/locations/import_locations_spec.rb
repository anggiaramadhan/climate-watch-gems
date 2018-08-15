require 'rails_helper'

RSpec.describe Locations::ImportLocations do
  let(:importer) { Locations::ImportLocations.new }
  subject { importer.call }

  before :all do
    Aws.config[:s3] = {
      stub_responses: {
        get_object: {
          body: <<~END
            iso_code3,iso_code2,pik_name,cait_name,ndcp_navigators_name,wri_standard_name,unfccc_group,location_type,show_in_cw
            ABW,,Aruba,,,,,COUNTRY,No
          END
        }
      }
    }
  end

  after :all do
    Aws.config[:s3] = {
      stub_responses: nil
    }
  end

  it 'Creates a new location' do
    allow(importer).to receive(:import_topojson).and_return(true)
    expect { subject }.to change { Location.count }.by(1)
  end
end
