module HistoricalEmissions
  class Filter
    include ColumnHelpers
    include HistoricalEmissions::FilterColumns
    attr_reader :header_years

    def initialize(params)
      @query = ::HistoricalEmissions::Record.from(
        "(#{historical_emissions_searchable_records}) historical_emissions_records"
      ).all
      @years_query = ::HistoricalEmissions::Record.from(
        "(#{historical_emissions_normalised_records}) historical_emissions_records"
      ).all
    end

    def call
      @years = @years_query.distinct(:year).pluck(:year).sort
      @header_years = @years.dup

      results = @query.
        select(select_columns)

      results
    end

    def year_value_column(year)
      "emissions_dict->'#{year}'"
    end

    def meta
      {
        years: @years,
        header_years: @header_years
      }.merge(sorting_manifest).merge(column_manifest)
    end

    # these 3 methods below encapsulate queries which in CW global are used to generate mviews
    # no mviews needed here

    def historical_emissions_normalised_records
      <<~SQL
        SELECT
          id,
          data_source_id,
          gwp_id,
          location_id,
          sector_id,
          gas_id,
          (JSONB_ARRAY_ELEMENTS(emissions)->>'year')::INT AS year,
          JSONB_ARRAY_ELEMENTS(emissions)->>'value' AS value
        FROM historical_emissions_records
      SQL
    end

    def historical_emissions_records_emissions
      <<~SQL
        SELECT
          id,
          JSONB_AGG(
              JSONB_BUILD_OBJECT(
                  'year', year,
                  'value', ROUND(value::NUMERIC, 2)
              )
          ) AS emissions,
          JSONB_OBJECT_AGG(
              year, ROUND(value::NUMERIC, 2)
          ) AS emissions_dict
        FROM (#{historical_emissions_normalised_records}) historical_emissions_records
        GROUP BY id
      SQL
    end

    def historical_emissions_searchable_records
      <<~SQL
        SELECT
          records.id,
          records.data_source_id,
          data_sources.name AS data_source,
          gwp_id,
          gwps.name AS gwp,
          location_id,
          locations.iso_code3 AS iso_code3,
          locations.wri_standard_name AS region,
          sector_id,
          sectors.name AS sector,
          gas_id,
          gases.name AS gas,
          records_emissions.emissions,
          emissions_dict
        FROM historical_emissions_records records
        JOIN historical_emissions_data_sources data_sources ON data_sources.id = records.data_source_id
        JOIN historical_emissions_gwps gwps ON gwps.id = records.gwp_id
        JOIN locations ON locations.id = records.location_id
        JOIN historical_emissions_sectors sectors ON sectors.id = records.sector_id
        JOIN historical_emissions_gases gases ON gases.id = records.gas_id
        LEFT JOIN (#{historical_emissions_records_emissions}) records_emissions ON records.id = records_emissions.id
      SQL
    end
  end
end
