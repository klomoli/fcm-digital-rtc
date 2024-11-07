class ItineraryOrganizerService < ApplicationService
  CONNECTION_INTERVAL_IN_DAYS = 1

  def initialize(segments, based_location)
    @segments = segments.sort_by(&:departure_date)
    @based_location = based_location
  end

  def call

    trips = []
    starting_segments = extract_starting_segments

    starting_segments.each do |segment|
      
      trip = create_trip_with_segments(segment)
      
      trips << trip
    end

    Itinerary.new(trips: trips)
  end

  private


  def extract_starting_segments
    starting_segments = @segments.select do |segment|
      segment.from == @based_location && (segment.type == "flight" || segment.type == "train")
    end
  end

  def create_trip_with_segments(starting_segment)
    trip = Trip.new(destination: starting_segment.to)
    connected_segments = []
    connected_segments << starting_segment
    @segments.each do |segment|
      next if segment.from != starting_segment.to

      if segment.type == "hotel" && segment.departure_date.strftime("%Y-%m-%d") == starting_segment.departure_date.strftime("%Y-%m-%d")
        connected_segments << segment
      elsif segment.type == "flight" || segment.type == "train"
        
        if (segment.from == starting_segment.to) && (segment.to == @based_location && segment.departure_date > starting_segment.arrival_date)
          connected_segments << segment
        else
          if segment.from == starting_segment.to && (segment.departure_date - starting_segment.arrival_date < CONNECTION_INTERVAL_IN_DAYS) && segment.departure_date > starting_segment.arrival_date
            connected_segments << segment
            trip.destination = connected_segments.last.to
          end
        end
      end
    end

    connected_segments.each { |segment| trip.add_segment(segment) }
    trip
  end
  


  
end
