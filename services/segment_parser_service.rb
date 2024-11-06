class SegmentParserService < ApplicationService

  DATE_REGEX = /\d{4}-\d{2}-\d{2}/
  TIME_REGEX = /\d{2}:\d{2}/
  IATA_REGEX = /[A-Z]{3}/ #IATAs are always three-letter capital words: SVQ, MAD, BCN, NYC

  def initialize(reservations, pattern)
    @reservations = reservations # Array of strings of segments
    @pattern = pattern
  end

  def call
    segments = []
    @reservations.each do |reservation|
      # Each array element delimited by the pattern is processed with strip to remove whitespace/tabs or line breaks,
      # and we apply reject to remove any empty elements. This may happen if we encounter RESERVATION RESERVATION.
      lines_data = reservation.split(@pattern).map(&:strip).reject(&:empty?)
      lines_data.each do |segment|
        segments << parse_segment(segment)
      end
    end

    segments
  end

  private

    # We should work with a type hotel segment or flight segment correctly
    # flight / train (transport) work with departure and arrival date, origen and destination
    # hotel work with ubication and checkin and checkout date

    # We work with a regex to parse the line and get the data we need
    def parse_segment(line)
      case line
      when /Flight/
        parse_flight(line)
      when /Train/
        parse_train(line)
      when /Hotel/
        parse_hotel(line)
      else
        raise "Unknown segment type"
      end
    end

    # we should provide a solution easy to extend, if we want to add a new type of segment 

    def parse_flight(line)
      if line.match(/Flight #{IATA_REGEX} #{DATE_REGEX} #{TIME_REGEX} -> #{IATA_REGEX} #{TIME_REGEX}/)
        data = line.split
        type = "flight"
        from = data[1]
        departure_date = "#{data[2]} #{data[3]}"
        to = data[5]
        arrival_date = "#{data[6]}"
        Segment.new(type: type, from: from, to: to, departure_date: departure_date, arrival_date: arrival_date)
      end
    end
  
    def parse_train(line)
      if line.match(/Train #{IATA_REGEX} #{DATE_REGEX} #{TIME_REGEX} -> #{IATA_REGEX} #{TIME_REGEX}/)
        data = line.split
        type = "train"
        from = data[1]
        departure_date = "#{data[2]} #{data[3]}"
        to = data[5]
        arrival_date = "#{data[6]}"
        Segment.new(type: type, from: from, to: to, departure_date: departure_date, arrival_date: arrival_date)
      end
    end
  
    def parse_hotel(line)
      if line.match(/Hotel #{IATA_REGEX} #{DATE_REGEX} -> #{DATE_REGEX}/)
        data = line.split
        type = "hotel"
        location = data[1]
        check_in_date = data[2]
        check_out_date = data[4]
        Segment.new(type: type, from: location, to: location, departure_date: check_in_date, arrival_date: check_out_date)
      end
    end
end