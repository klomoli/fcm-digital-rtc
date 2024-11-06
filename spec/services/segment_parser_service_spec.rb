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

  subject { described_class.new(reservations, '/SEGMENT:/') }

  describe '#parse_segment' do
    it 'return an array of Segment instances' do
      segments = subject.call
      expect(segments).to all(be_a(Segment))
    end
  end
end