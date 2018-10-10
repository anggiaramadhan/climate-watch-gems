Rails.application.routes.draw do
  mount DataUploader::Engine => "/data_uploader"
end
