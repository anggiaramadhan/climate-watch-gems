module HistoricalEmissions
  HistoricalEmissionsMetadata = Struct.new(
    :data_sources,
    :sectors,
    :gases,
    :gwps,
    :locations
  ) do
    alias_method :read_attribute_for_serialization, :send
  end

  class HistoricalEmissionsController < ApplicationController
    include ActionController::MimeResponds

    def index
      unless valid_params(params)
        render json: {
          status: :bad_request,
          error: 'Please specify `source` and at least one of `location`,'\
                 '`sector` or `gas`'
        }, status: :bad_request and return
      end

      respond_to do |format|
        format.json do
          values = ::HistoricalEmissions::Record.find_by_params(index_params)
          render json: values,
                 each_serializer: ::HistoricalEmissions::RecordSerializer,
                 params: index_params
        end

        format.csv do
          filter = HistoricalEmissions::Filter.new({})
          csv_content = HistoricalEmissions::CsvContent.new(filter).call
          send_data csv_content,
                    type: 'text/csv',
                    filename: 'historical_emissions.csv',
                    disposition: 'attachment'
        end
      end
    end

    def meta
      render(
        json: HistoricalEmissionsMetadata.new(
          merged_records(grouped_records),
          fetch_meta_sectors,
          ::HistoricalEmissions::Gas.all,
          ::HistoricalEmissions::Gwp.all,
          Location.all
        ),
        serializer: ::HistoricalEmissions::MetadataSerializer
      )
    end

    private

    def fetch_meta_sectors
      return ::HistoricalEmissions::Sector.all if deeply_nested_sectors?

      ::HistoricalEmissions::Sector.first_and_second_level
    end

    def index_params
      return params if deeply_nested_sectors?

      not_deeply_nested_ids = ::HistoricalEmissions::Sector.first_and_second_level.pluck(:id)
      sector_ids = (params[:sector] || '').split(',') | not_deeply_nested_ids

      params.merge(sector: sector_ids.join(','))
    end

    def valid_params(params)
      params[:source] && (
        params[:location] || params[:sector] || params[:gas]
      )
    end

    def deeply_nested_sectors?
      params.fetch(:deeply_nested_sectors, 'true') == 'true'
    end

    def grouped_records
      ::HistoricalEmissions::Record.
        select(
          <<-SQL
            data_source_id,
            ARRAY_AGG(DISTINCT sector_id) AS sector_ids,
            ARRAY_AGG(DISTINCT gas_id) AS gas_ids,
            ARRAY_AGG(DISTINCT location_id) AS location_ids,
            ARRAY_AGG(DISTINCT gwp_id) AS gwp_ids
          SQL
        ).
        group('data_source_id').
        as_json.
        map { |h| [h['data_source_id'], h.symbolize_keys.except(:id)] }.
        to_h
    end

    def merged_records(records)
      ::HistoricalEmissions::DataSource.
        all.map do |source|
          {
            id: source.id,
            name: source.name
          }.merge(records[source.id])
        end
    end
  end
end
