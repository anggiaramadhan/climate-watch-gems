class DummyImportWorker < DataUploader::BaseImportWorker
  private

  def import_data
    DummyImporter.new.call
  end
end
