class ItineraryOrganizerService < ApplicationService
  CONNECTION_INTERVAL_IN_DAYS = 1

  def initialize(segments, based_location)
    @segments = segments.sort_by(&:departure_date)
    @based_location = based_location
  end

  def call
    trips = starting_segments.map do |segment|
      build_trip(segment)
    end
            
    Itinerary.new(trips: trips)
  end

  private


  def starting_segments
    @segments.select { |segment| starting_from_based_location?(segment) }
  end

  def build_trip(starting_segment)
    trip = Trip.new(destination: starting_segment.to)
    connected_segments = connected_segments(starting_segment, trip)
    
    connected_segments.each { |segment| trip.add_segment(segment) }
    trip
  end


  def starting_from_based_location?(segment)
    segment.from == @based_location && segment.is_transport_segment?
  end

  def connected_segments(starting_segment, trip)
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
            updated_trip_destination(trip, segment)
          end
        end
      end
    end
    connected_segments
  end


  def updated_trip_destination(trip, segment)
    trip.destination = segment.to
  end

  
  


  
end
