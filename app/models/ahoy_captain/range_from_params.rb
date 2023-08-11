module AhoyCaptain
  class RangeFromParams
    def self.from_params(params)
      new(period: params[:period], start_date: params[:start_date], end_date: params[:end_date]).tap { |instance| instance.build }
    end

    attr_reader :params, :range
    def initialize(period: AhoyCaptain.config.ranges.default, start_date: nil, end_date: nil)
      @period = period || AhoyCaptain.config.ranges.default
      @start_date = start_date
      @end_date = end_date
      @range = nil
    end

    def build
      if @start_date.present? && @end_date.present?
        custom = [@start_date.to_datetime, @end_date.to_datetime].sort
        duration = (custom[1].to_date -  custom[0].to_date)

        if AhoyCaptain.config.ranges.max && (duration.days <= AhoyCaptain.config.ranges.max)
          @range = Range.new(custom[0], custom[1])
          return self
        end
      end

      @range = Range.new(*selected_period)
      self
    end

    def starts_at
      Time.at(@range.min)
    end

    def ends_at
      if realtime?
        Time.current
      else
        Time.at(@range.max)
      end
    end

    def realtime?
      @range.end.nil?
    end

    def [](value)
      if value == 0
        starts_at
      elsif value == 1
        ends_at
      else
        raise NoMethodError
      end
    end

    # return an integer-based range which works with step
    def numeric
      @numeric ||= Range.new(starts_at.to_i, ends_at.to_i)
    end

    def selected_period
      AhoyCaptain.config.ranges.for(@period) || AhoyCaptain.config.ranges.default
    end
  end
end
