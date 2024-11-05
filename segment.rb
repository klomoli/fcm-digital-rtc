class Segment 
    attr_accessor :type, :from, :to, :departure_date, :arrival_date

    def initialize(type:, from:, to:, departure_date:, arrival_date:)
      @type = type
      @from = from
      @to = to
      @departure_date = departure_date
      @arrival_date = arrival_date
    end

    def to_s
      case @type.downcase
      when "flight", "train"
        "#{@type.capitalize} from #{@from} to #{@to} at #{@departure_date} to #{@arrival_date}"
      when "hotel"
        "#{@type.capitalize} at #{@from} on #{@departure_date} to #{@arrival_date}"
      else
        "#{@type.capitalize} segment from #{@from} to #{@to} at #{@departure_date} to #{@arrival_date}"
      end
    end
end