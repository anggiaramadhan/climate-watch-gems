module DataUploader
  class Platform < ApplicationRecord
    self.table_name = 'platforms'
    has_many :sections, class_name: 'DataUploader::Section'
    validates :name, presence: true
  end
end
