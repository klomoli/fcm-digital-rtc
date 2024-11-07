require 'rspec'
require_relative '../../services/application_service'
require_relative '../../services/itinerary_organizer_service'
require_relative '../../models/segment'
require_relative '../../models/trip'
require_relative '../../models/itinerary'

RSpec.describe ItineraryOrganizerService do
    let(:based_location) { 'SVQ' }

    let(:flight1) { Segment.new(type: 'flight', from: 'SVQ', to: 'BCN', departure_date: DateTime.parse('2023-01-05 20:40'), arrival_date: DateTime.parse('2023-01-05 22:10')) }
    let(:hotel1) { Segment.new(type: 'hotel', from: 'BCN', to: 'BCN', departure_date: DateTime.parse('2023-01-05'), arrival_date: DateTime.parse('2023-01-10')) }
    let(:flight2) { Segment.new(type: 'flight', from: 'BCN', to: 'SVQ', departure_date: DateTime.parse('2023-01-10 10:30'), arrival_date: DateTime.parse('2023-01-10 11:50')) }
    let(:train1) { Segment.new(type: 'train', from: 'SVQ', to: 'MAD', departure_date: DateTime.parse('2023-02-15 09:30'), arrival_date: DateTime.parse('2023-02-15 11:00')) }
    let(:hotel2) { Segment.new(type: 'hotel', from: 'MAD', to: 'MAD', departure_date: DateTime.parse('2023-02-15'), arrival_date: DateTime.parse('2023-02-17')) }
    let(:train2) { Segment.new(type: 'train', from: 'MAD', to: 'SVQ', departure_date: DateTime.parse('2023-02-17 17:00'), arrival_date: DateTime.parse('2023-02-17 19:30')) }
    let(:flight3) { Segment.new(type: 'flight', from: 'SVQ', to: 'BCN', departure_date: DateTime.parse('2023-03-02 06:40'), arrival_date: DateTime.parse('2023-03-02 09:10')) }
    let(:flight4) { Segment.new(type: 'flight', from: 'BCN', to: 'NYC', departure_date: DateTime.parse('2023-03-02 15:00'), arrival_date: DateTime.parse('2023-03-02 22:45')) }
  
    let(:segments) { [hotel1,flight1, flight2, train1, hotel2, train2, flight3, flight4] }

    describe '#call' do
      subject { described_class.new(segments, based_location) }

      it 'created correct number of trips' do
        itinerary = subject.call
        expect(itinerary.trips.size).to eq(3)
      end

      it 'created correct number of segments for each trip' do
        itinerary = subject.call
        expect(itinerary.trips[0].segments.size).to eq(3)
        expect(itinerary.trips[1].segments.size).to eq(3)
        expect(itinerary.trips[2].segments.size).to eq(2)
      end

      it 'created correct connections if there is less than 24 hours difference' do
        itinerary = subject.call
        expect(itinerary.trips[2].destination).to eq('NYC')  
      end

      it 'created correct connections if there is more than 24 hours difference' do
        itinerary = subject.call
        expect(itinerary.trips[0].destination).to eq('BCN')  
        expect(itinerary.trips[1].destination).to eq('MAD')  
      end
      
    end
  
end