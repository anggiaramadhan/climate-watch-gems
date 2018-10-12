namespace :data_uploader do
  desc 'Generate the admin controllers from a YAML file'
  task generate: :environment do
    TimedLogger.log('generate admin controllers') do
      DataUploader::GenerateAdminControllers.new.call
    end
  end
end
