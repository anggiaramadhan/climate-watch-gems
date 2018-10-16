module DataUploader
  class Section < ApplicationRecord
    self.table_name = 'sections'
    belongs_to :platform, class_name: 'DataUploader::Platform'
    has_many :datasets, class_name: 'DataUploader::Dataset'
    has_many :worker_logs, class_name: 'DataUploader::WorkerLog'
    validates :name, presence: true
  end
end
