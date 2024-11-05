require_relative 'models/segment'
require_relative 'models/trip'
require_relative 'models/itinerary'
require_relative 'services/application_service'
require_relative 'services/file_reader_reservations_service'
require_relative 'services/segment_parser_service'

reservations = FileReaderReservationsService.call('input.txt')
segments = SegmentParserService.call(reservations, 'SEGMENT:')

segments.each do |segment|
  puts segment.to_s
end