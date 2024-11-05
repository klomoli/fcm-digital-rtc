require_relative 'segment'
require_relative 'trip'
require_relative 'itinerary'
require_relative 'services/application_service'
require_relative 'services/file_reader_reservations_service'
require_relative 'services/segment_parser_service'

reservations = FileReaderReservationsService.call('input.txt')
segments = SegmentParserService.call(reservations)

segments.each do |segment|
    puts segment.to_s
end