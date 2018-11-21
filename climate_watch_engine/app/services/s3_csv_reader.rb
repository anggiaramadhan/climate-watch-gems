require 'csv'

module S3CSVReader
  def self.strip(hash)
    hash.map do |first, second|
      [first, second.strip]
    end.to_h
  end

  # @param header_converter [Symbol] default :symbol
  def self.read(filename, header_converters = :symbol)
    bucket_name = ClimateWatchEngine.s3_bucket_name
    s3 = Aws::S3::Client.new

    begin
      file = s3.get_object(bucket: bucket_name, key: filename)
    rescue Aws::S3::Errors::NoSuchKey
      Rails.logger.error "File #{filename} not found in #{bucket_name}"
      return
    end

    hard_space_converter = ->(f) { f&.gsub(160.chr('UTF-8'), 32.chr) }
    strip_converter = ->(field, _) { field&.strip }

    CSV.parse(
      file.body.read,
      headers: true,
      converters: [hard_space_converter, strip_converter],
      header_converters: header_converters
    )
  end
end
