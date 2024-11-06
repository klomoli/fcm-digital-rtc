require_relative 'models/segment'
require_relative 'models/trip'
require_relative 'models/itinerary'
require_relative 'services/application_service'
require_relative 'services/file_reader_reservations_service'
require_relative 'services/segment_parser_service'

file_path = ARGV[0]
raise "Please provide a file path: bundle exec ruby main.rb path_to_txt" if file_path.nil?

reservations = FileReaderReservationsService.call(file_path)
segments = SegmentParserService.call(reservations, 'SEGMENT:')

segments.each do |segment|
  puts segment.to_s
end