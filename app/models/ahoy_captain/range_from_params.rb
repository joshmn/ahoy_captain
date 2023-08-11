module AhoyCaptain
  class RangeFromParams
    def self.build(params)
      new(params).tap { |instance| instance.build }
    end

    attr_reader :params, :range
    def initialize(params)
      @params = params
      @range = nil
    end

    def build
      if params[:start_date].present? && params[:end_date].present?
        custom = [params[:start_date].to_datetime, params[:end_date].to_datetime].sort
        duration = (custom[1].to_date -  custom[0].to_date)

        if AhoyCaptain.config.ranges.max && (duration.days <= AhoyCaptain.config.ranges.max)
          @range = Range.new(custom[0], custom[1])
          return
        end
      end

      @range = Range.new(*AhoyCaptain.config.ranges.for(period))
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

    def period
      params[:period] || AhoyCaptain.config.ranges.default
    end

    # return an integer-based range which works with step
    def numeric
      @numeric ||= Range.new(starts_at.to_i, ends_at.to_i)
    end
  end
end
