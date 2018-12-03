module ClimateWatchEngine
  module CSVImporter
    extend ActiveSupport::Concern

    class_methods do
      def headers(*attrs)
        define_method(:headers) do
          if attrs.any? { |a| a.is_a?(Hash) }
            attrs.reduce({}, :merge)
          else
            attrs
          end
        end
      end
    end

    def valid_headers?(csv, filename, headers)
      (headers - csv.headers).each do |value|
        msg = "#{File.basename(filename)}: Missing header #{value}"
        STDERR.puts msg
        add_error(:missing_header, msg: msg, row: 1)
      end.empty?
    end

    def errors
      @errors ||= []
    end

    def add_error(type, details = {})
      msg = details.fetch(:msg, 'Error')
      errors << {type: type, msg: msg}.merge(details.except(:msg))
    end

    def import_each_with_logging(csv, filename)
      csv.each.with_index(2) do |row, row_index|
        with_logging(filename, row_index) do
          yield row
        end
      end
    end

    def with_logging(filepath, row_index)
      yield
    rescue ActiveRecord::RecordInvalid => invalid
      filename = File.basename(filepath)
      msg = "#{filename}: Error importing row #{row_index}: #{invalid}"
      STDERR.puts msg
      add_error(:invalid_row, msg: msg, row: row_index, filename: filename)
    end
  end
end
