class FileReaderReservationsService < ApplicationService
  def initialize(file_path)
    @file_path = file_path
  end

  def call
    File.read(@file_path).split("RESERVATION").map(&:strip).reject(&:empty?)
  end
end