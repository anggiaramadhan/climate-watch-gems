module DataUploader
  module UseCase
    class UploadDatafile < DataUploader::UseCase::Base
      def call(params, callbacks)
        validate_if_file_chosen params, callbacks
        validate_content_type_against_csv params, callbacks

        dataset = repository.find(params[:dataset_id])

        validate_filename(dataset, params)

        dataset.datafile.attach(params[:datafile])

        DataUploader::S3Uploader.call(
          dataset.datafile.attachment,
          s3_folder_path
        )

        callbacks[:success].call
      end

      private

      def validate_if_file_chosen(params, callbacks)
        params[:datafile].nil? && callbacks[:datafile_not_chosen].call
      end

      def validate_content_type_against_csv(params, callbacks)
        permitted_mime_types = ['text/csv', 'text/comma-separated-values',
                                'application/csv', 'text/plain']
        return if permitted_mime_types.include?(params[:datafile].content_type)
        callbacks[:datafile_wrong_content_type].call
      end

      def validate_filename(dataset, params)
        expected_filename = "#{dataset.name}.csv"

        params[:datafile].original_filename =
          DataUploader::Helpers::CheckFilenamesMatch.call(
            params[:datafile].original_filename,
            expected_filename
          )
      end
    end
  end
end
