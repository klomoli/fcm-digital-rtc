require_relative 'models/segment'
require_relative 'models/trip'
require_relative 'models/itinerary'
require_relative 'services/application_service'
require_relative 'services/file_reader_reservations_service'
require_relative 'services/segment_parser_service'
require_relative 'services/itinerary_organizer_service'

file_path = ARGV[0]
based_location = ENV['BASED']
raise "Please provide a file path, for example: BASED=SVQ ruby main.rb <input_file>" if file_path.nil?
raise "Please provide a based location, for example: BASED=SVQ ruby main.rb <input_file>" if based_location.nil?

reservations = FileReaderReservationsService.call(file_path)
segments = SegmentParserService.call(reservations, 'SEGMENT:')


itinerary = ItineraryOrganizerService.call(segments, based_location)

puts itinerary.trips.map(&:to_s).join("\n\n")
