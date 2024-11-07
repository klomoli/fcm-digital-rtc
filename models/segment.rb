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
        "#{@type.capitalize} from #{@from} to #{@to} at #{format_datetime(@departure_date)} to #{format_hours(@arrival_date)}"
      when "hotel"
        "#{@type.capitalize} at #{@from} on #{format_date(@departure_date)} to #{format_date(@arrival_date)}"
      else
        "#{@type.capitalize} segment from #{@from} to #{@to} at #{format_datetime(@departure_date)} to #{foramt_hours(@arrival_date)}"
      end
    end

    def format_datetime(datetime)
      datetime.strftime("%Y-%m-%d %H:%M")
    end

    def format_date(date)
      date.strftime("%Y-%m-%d")
    end

    def format_hours(date)
      date.strftime("%H:%M")
    end

end