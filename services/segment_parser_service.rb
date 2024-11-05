class SegmentParserService < ApplicationService

  DATE_REGEX = /\d{4}-\d{2}-\d{2}/
  TIME_REGEX = /\d{2}:\d{2}/
  IATA_REGEX = /[A-Z]{3}/ #IATAs are always three-letter capital words: SVQ, MAD, BCN, NYC

  def initialize(reservations)
    @reservations = reservations
  end

  def call
    segments = []
    @reservations.each do |line|
       segments << parse_segment(line) if line.start_with?("SEGMENT:")
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
        from = data[2]
        departure_date = "#{data[3]} #{data[4]}"
        to = data[6]
        arrival_date = "#{data[7]}"
        Segment.new(type: type, from: from, to: to, departure_date: departure_date, arrival_date: arrival_date)
      end
    end
  
    def parse_train(line)
      if line.match(/Train #{IATA_REGEX} #{DATE_REGEX} #{TIME_REGEX} -> #{IATA_REGEX} #{TIME_REGEX}/)
        data = line.split
        type = "train"
        from = data[2]
        departure_date = "#{data[3]} #{data[4]}"
        to = data[6]
        arrival_date = "#{data[7]}"
        Segment.new(type: type, from: from, to: to, departure_date: departure_date, arrival_date: arrival_date)
      end
    end
  
    def parse_hotel(line)
      if line.match(/Hotel #{IATA_REGEX} #{DATE_REGEX} -> #{DATE_REGEX}/)
        data = line.split
        type = "hotel"
        location = data[2]
        check_in_date = data[3]
        check_out_date = data[5]
        Segment.new(type: type, from: location, to: location, departure_date: check_in_date, arrival_date: check_out_date)
      end
    end
end