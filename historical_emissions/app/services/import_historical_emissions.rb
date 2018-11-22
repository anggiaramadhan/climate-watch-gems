class ImportHistoricalEmissions
  def call
    cleanup
    import_sectors(S3CSVReader.read(HistoricalEmissions.meta_sectors_filepath))
    import_records(S3CSVReader.read(HistoricalEmissions.data_cait_filepath))
    import_records(S3CSVReader.read(HistoricalEmissions.data_pik_filepath))
    import_records(S3CSVReader.read(HistoricalEmissions.data_unfccc_filepath))
  end

  private

  def cleanup
    HistoricalEmissions::DataSource.delete_all
    HistoricalEmissions::Sector.delete_all
    HistoricalEmissions::Gas.delete_all
    HistoricalEmissions::Record.delete_all
    HistoricalEmissions::Record.delete_all
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

  def import_sectors(content)
    content.each do |row|
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

  def import_records(content)
    content.each do |row|
      begin
        HistoricalEmissions::Record.create!(record_attributes(row))
      rescue ActiveRecord::RecordInvalid => invalid
        STDERR.puts "Error importing #{row.to_s.chomp}: #{invalid}"
      end
    end
  end
end
