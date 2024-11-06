require 'rspec'
require_relative '../../services/application_service'
require_relative '../../services/segment_parser_service'
require_relative '../../models/segment'

RSpec.describe SegmentParserService do
  let(:reservations) do 
    [
      "SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10",
      "SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10",
      "SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10"
    ]
  end

  subject { described_class.new(reservations, 'SEGMENT:') }

  describe '#parse_segment' do
    it 'return an array of Segment instances' do
      segments = subject.call
      expect(segments).to all(be_a(Segment))
    end

    it 'parses a flight segment correctly' do
      segments = subject.call
      flight_segment = segments.first
      expect(flight_segment.type).to eq('flight')
      expect(flight_segment.from).to eq('SVQ')
      expect(flight_segment.to).to eq('BCN')
      expect(flight_segment.departure_date).to eq('2023-03-02 06:40')
      expect(flight_segment.arrival_date).to eq('09:10')
    end

    it 'parses a hotel segment correctly' do
      segments = subject.call
      hotel_segment = segments[1]
      expect(hotel_segment.type).to eq('hotel')
      expect(hotel_segment.from).to eq('BCN')
      expect(hotel_segment.to).to eq('BCN')
      expect(hotel_segment.departure_date).to eq('2023-01-05')
      expect(hotel_segment.arrival_date).to eq('2023-01-10')
    end

    it 'raise an error if the segment type is unknown' do
      invalid_segment = "SEGMENT: Bus SVQ 2023-03-02 06:40 -> BCN 09:10"
      expect { subject.send(:parse_segment, invalid_segment) }.to raise_error("Unknown segment type")
    end
  end
end