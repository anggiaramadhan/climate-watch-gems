require 'rails_helper'
require 'dummy/app/admin/test_platform/test_section.rb'

RSpec.describe Admin::TestPlatformTestSectionController, type: :controller do
  let(:user) { FactoryBot.create(:admin_user) }
  before do
    Dummy::Application.reload_routes!
    sign_in user
  end

  describe 'GET index' do
    it 'should be successful' do
      post :index
      expect(response).to be_success
    end
  end

  describe 'POST run_importer' do
    before(:each) do
      FactoryBot.create(
        :section,
        name: 'test_section',
        platform: FactoryBot.create(:platform, name: 'test_platform')
      )
    end
    it 'runs the importer' do
      expect(DummyImportWorker).to receive(:perform_async)
      post :run_importer
    end
  end

  describe 'GET download_datafiles' do
    it 'runs the zip downloader' do
      expect_any_instance_of(DataUploader::UseCase::DownloadZippedDatafiles).to receive(:call)
      post :download_datafiles
    end
  end

  describe 'GET download_datafile' do
    it 'runs the downloader' do
      expect_any_instance_of(DataUploader::UseCase::DownloadDatafile).to receive(:call)
      post :download_datafile
    end
  end
end
