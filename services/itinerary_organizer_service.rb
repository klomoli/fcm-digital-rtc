class ItineraryOrganizerService < ApplicationService
  CONNECTION_INTERVAL_IN_DAYS = 1

  def initialize(segments, based_location)
    @segments = segments.sort_by(&:departure_date)
    @based_location = based_location
  end

  def call
    trips = starting_segments.map do |starting_segment|
      generate_trip_from_segment(starting_segment)
    end
            
    Itinerary.new(trips: trips)
  end

  private


  def starting_segments
    @segments.select { |segment| starting_from_based_location?(segment) }
  end



  def generate_trip_from_segment(starting_segment)
    trip = Trip.new(destination: starting_segment.to)
    connected_segments(starting_segment, trip)
    # search destination for interval connection
    trip.destination = trip.last_segment.to if trip.last_segment.to != @based_location
    trip
  end

  # Recursive way to find the connected segments
  def connected_segments(starting_segment, trip)
    trip.add_segment(starting_segment)

    next_segment = find_next_segment(starting_segment.to, starting_segment.arrival_date)

    #recursive case
    connected_segments(next_segment, trip) if next_segment # based case , if exists next segment
  end


  def find_next_segment(destination, arrival_date)

    @segments.find do |segment|
      segment.from == destination && (
        hotel_in_same_day?(segment, arrival_date) || 
        transport_segment_connected?(segment, arrival_date)
      )
    end
  end

  # we work with two conditions, 
    #if the segment is a hotel and the departure date is the same as the arrival date of current segment
    # or if the segment is a transport segment and the destination is the same as the based location and the departure date is greater than the arrival date of the current segment
    # or is a connection interval

  def hotel_in_same_day?(segment, arrival_date)
    segment.is_hotel? && segment.departure_date.strftime("%Y-%m-%d") == arrival_date.strftime("%Y-%m-%d")
  end

  def transport_segment_connected?(segment, arrival_date)
    segment.is_transport?  &&
    connection_interval?(segment, arrival_date) &&
    segment.departure_date > arrival_date
  end

  # auxiliar methods
  def starting_from_based_location?(segment)
    segment.from == @based_location
  end

  def connection_interval?(segment, arrival_date)
    ((segment.departure_date - arrival_date).to_f < CONNECTION_INTERVAL_IN_DAYS)
  end
  
  def returning_to_based_location?(segment, arrival_date)
    (segment.to == @based_location && segment.departure_date > arrival_date)
  end


  
end
