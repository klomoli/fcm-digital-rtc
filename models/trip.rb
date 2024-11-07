class Trip 
    attr_accessor :destination, :segments

    def initialize(destination:)
      @segments = []
      @destination = destination
    end

    def add_segment(segment)
      @segments << segment
    end

    def last_segment
      @segments.last
    end

    def to_s
      "Trip to #{@destination}\n" + @segments.map(&:to_s).join("\n")
    end
end