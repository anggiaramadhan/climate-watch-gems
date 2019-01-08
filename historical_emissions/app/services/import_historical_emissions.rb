class ImportHistoricalEmissions
  include ClimateWatchEngine::CSVImporter

  headers metadata: [:source, :sector, :subsectorof],
          records: [:country, :source, :sector, :gas, :gwp]

  def call
    return unless all_headers_valid?

    ActiveRecord::Base.transaction do
      cleanup
      import_sectors(meta_sectors_csv, HistoricalEmissions.meta_sectors_filepath)
      import_records(data_cait_csv, HistoricalEmissions.data_cait_filepath)
      import_records(data_pik_csv, HistoricalEmissions.data_pik_filepath)
      import_records(data_unfccc_csv, HistoricalEmissions.data_unfccc_filepath)
    end
  end

  private

  def cleanup
    HistoricalEmissions::DataSource.delete_all
    HistoricalEmissions::Sector.delete_all
    HistoricalEmissions::Gas.delete_all
    HistoricalEmissions::Record.delete_all
  end

  def meta_sectors_csv
    @meta_sectors_csv ||= S3CSVReader.read(HistoricalEmissions.meta_sectors_filepath)
  end

  def data_cait_csv
    @data_cait_csv ||= S3CSVReader.read(HistoricalEmissions.data_cait_filepath)
  end

  def data_pik_csv
    @data_pik_csv ||= S3CSVReader.read(HistoricalEmissions.data_pik_filepath)
  end

  def data_unfccc_csv
    @data_unfccc_csv ||= S3CSVReader.read(HistoricalEmissions.data_unfccc_filepath)
  end

  def all_headers_valid?
    [
      valid_headers?(meta_sectors_csv, HistoricalEmissions.meta_sectors_filepath, headers[:metadata]),
      valid_headers?(data_cait_csv, HistoricalEmissions.data_cait_filepath, headers[:records]),
      valid_headers?(data_pik_csv, HistoricalEmissions.data_pik_filepath, headers[:records]),
      valid_headers?(data_unfccc_csv, HistoricalEmissions.data_unfccc_filepath, headers[:records])
    ].all?(true)
  end

  def sector_attributes(row)
    {
      name: row[:sector],
      data_source: HistoricalEmissions::DataSource.find_or_create_by(
        name: row[:source]
      ),
      annex_type: row[:annex_type],
      parent: row[:subsectorof] &&
        HistoricalEmissions::Sector.find_or_create_by(name: row[:subsectorof])
    }
  end

  def import_sectors(content, filepath)
    import_each_with_logging(content, filepath) do |row|
      next if HistoricalEmissions::Sector.find_by(name: row[:sector])
      sector = sector_attributes(row)
      HistoricalEmissions::Sector.create!(sector)
    end
  end

  def emissions(row)
    row.headers.grep(/\d{4}/).map do |year|
      {year: year.to_s.to_i, value: row[year]&.delete(',')&.to_f}
    end
  end

  def record_attributes(row)
    {
      location: Location.find_by(iso_code3: row[:country]),
      data_source: HistoricalEmissions::DataSource.find_by(name: row[:source]),
      sector: HistoricalEmissions::Sector.find_by(name: row[:sector]),
      gas: HistoricalEmissions::Gas.find_or_create_by(name: row[:gas]),
      gwp: HistoricalEmissions::Gwp.find_or_create_by(name: row[:gwp]),
      emissions: emissions(row)
    }
  end

  def import_records(content, filepath)
    import_each_with_logging(content, filepath) do |row|
      HistoricalEmissions::Record.create!(record_attributes(row))
    end
  end
end
