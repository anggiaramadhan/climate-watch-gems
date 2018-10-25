module DataUploader
  class Dataset < ApplicationRecord
    self.table_name = 'datasets'
    belongs_to :section, class_name: 'DataUploader::Section'
    has_one_attached :datafile
  end
end
