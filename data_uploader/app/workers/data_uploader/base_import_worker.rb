module DataUploader
  class BaseImportWorker
    include Sidekiq::Worker
    include DataUploader::WithJobLogging

    sidekiq_options queue: :database, retry: false

    def perform(section_id)
      section = DataUploader::Section.find(section_id)

      return if job_in_progress?(section)

      log_job(jid, section_id) { import_data }
    end

    private

    def job_in_progress?(section)
      section.worker_logs.started.any?
    end
  end
end
