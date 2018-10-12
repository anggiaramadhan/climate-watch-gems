require 'rails_helper'

RSpec.describe DataUploader::GenerateAdminControllers do
  subject { DataUploader::GenerateAdminControllers.new }

  it 'Creates new active admin file' do
    subject.call
    expect(File).to exist("#{Rails.root}/app/admin/test_platform/test_section.rb")
  end
end
