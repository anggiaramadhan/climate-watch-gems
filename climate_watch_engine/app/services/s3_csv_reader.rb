require 'csv'

class S3CSVReader
  include Singleton

  FileLoadingError = Class.new(StandardError)

  class << self
    delegate :read, to: :instance
  end

  # @param header_converter [Symbol] default :symbol
  def read(filename, header_converters: :symbol)
    file = get_file(filename)

    return if file.nil?

    parse(file, header_converters)
  rescue StandardError => e
    raise FileLoadingError, "Error while loading #{File.basename(filename)}: #{e}"
  end

  private

  def get_file(filename)
    s3 = Aws::S3::Client.new
    bucket = ClimateWatchEngine.s3_bucket_name
    s3.get_object(bucket: bucket, key: filename)
  rescue Aws::S3::Errors::NoSuchKey
    Rails.logger.error "File #{filename} not found in #{bucket}"
  end

  def parse(file, header_converters)
    hard_space_converter = ->(f) { f&.gsub(160.chr('UTF-8'), 32.chr) }
    strip_converter = ->(field, _) { field&.strip }

    CSV.parse(
      file.body.read,
      headers: true,
      skip_blanks: true,
      converters: [hard_space_converter, strip_converter],
      header_converters: header_converters
    )
  end
end
