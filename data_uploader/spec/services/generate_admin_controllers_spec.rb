require 'rails_helper'

RSpec.describe DataUploader::GenerateAdminControllers do
  before(:each) do
    FileUtils.cp(
      "#{Rails.root}/config/data_uploader.yml",
      "#{Rails.root}/config/data_uploader.yml.backup"
    )
    FileUtils.cp(
      "#{Rails.root}/config/data_uploader_gen_test.yml",
      "#{Rails.root}/config/data_uploader.yml"
    )
  end
  after(:each) do
    FileUtils.mv(
      "#{Rails.root}/config/data_uploader.yml.backup",
      "#{Rails.root}/config/data_uploader.yml"
    )
    FileUtils.rm_r("#{Rails.root}/app/admin/gen_test_platform", force: true)
  end
  subject { DataUploader::GenerateAdminControllers.new }

  it 'Creates new active admin file' do
    subject.call
    path = "#{Rails.root}/app/admin/gen_test_platform/gen_test_section.rb"
    expect(File).to exist(path)
  end
end
