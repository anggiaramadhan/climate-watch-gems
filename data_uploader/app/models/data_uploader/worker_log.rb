module DataUploader
  class WorkerLog < ApplicationRecord
    self.table_name = 'worker_logs'
    belongs_to :section, class_name: 'DataUploader::Section'

    enum state: {
      started: 1,
      finished: 2,
      failed: 3,
      dead: 4
    }
  end
end
