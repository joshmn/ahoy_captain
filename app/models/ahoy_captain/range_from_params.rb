module AhoyCaptain
  class RangeFromParams
    def self.from_params(params)

      compare = ComparisonMode.new(params)
      new(period: params[:period], start_date: params[:start_date], end_date: params[:end_date], date: params[:date], comparison: compare.enabled?(false), raw: params).tap { |instance| instance.build }
    end

    attr_reader :params, :range
    def initialize(period: AhoyCaptain.config.ranges.default, start_date: nil, end_date: nil, date: nil, comparison: false, raw: {})
      @period = period || AhoyCaptain.config.ranges.default
      @start_date = start_date
      @end_date = end_date
      @date = date
      @range = nil
      @comparison = comparison
      @raw = raw
    end

    def build
      if (@start_date.present? && @end_date.present?) || @date.present?
        if @date
          @start_date ||= @date.to_datetime.beginning_of_day
          @end_date ||= @date.to_datetime.end_of_day
        end

        custom = [@start_date.to_datetime, @end_date.to_datetime].sort
        duration = (custom[1].to_date -  custom[0].to_date)

        #   if AhoyCaptain.config.ranges.max && (duration.days <= AhoyCaptain.config.ranges.max)
          @range = Range.new(custom[0].utc, custom[1].utc)
          return self
        #   end
      end

      @range = Range.new(selected_period[0], selected_period[1])
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

    def custom?
      @raw[:start_date].present? && @raw[:end_date].present?
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
