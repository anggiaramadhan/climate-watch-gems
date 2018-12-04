module DataUploader
  module WithJobLogging
    def log_job(jid, section_id, admin)
      log = create_job_log(jid, section_id, admin) unless job_log(jid)

      result = yield

      if result.respond_to?(:errors)
        log.details['errors'] = result.errors if result.errors&.any?
        any_missing_header?(result) ? log.failed! : log.finished!
      else
        log.finished!
      end
    rescue StandardError => e
      mark_job_as_failed(jid, e)
    end

    private

    def create_job_log(jid, section_id, admin)
      DataUploader::WorkerLog.create(
        jid: jid,
        state: 'started',
        section_id: section_id,
        user_email: admin
      )
    end

    def job_log(jid)
      DataUploader::WorkerLog.find_by(jid: jid)
    end

    def mark_job_as_failed(jid, error)
      job = job_log(jid)
      job.details['errors'] = [{
        type: :error,
        msg: error
      }]
      job.failed!
    end

    def any_missing_header?(result)
      result.errors&.any? { |e| e[:type] == :missing_header }
    end
  end
end
