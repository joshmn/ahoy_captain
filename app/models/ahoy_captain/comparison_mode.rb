module AhoyCaptain
  class ComparisonMode
    VALID_COMPARISONS = %w{previous year true}

    include RangeOptions
    include Rangeable

    attr_reader :params
    def initialize(params)
      @params = params
    end

    # can't compare realtime
    def enabled?(strict = true)
      comparing = (params[:comparison].in?(VALID_COMPARISONS) || custom_compare?)
      if strict
        comparing && !range.realtime?
      else
        comparing
      end
    end

    def label
      if custom_compare?
        return "Custom period"
      end

      if type == :true || type == :previous
        "Previous period"
      elsif type == :year
        "Year-over-year"
      else
        raise ArgumentError
      end
    end

    def compared_to_range
      return custom_compare if custom_compare?

      if type == :true || type == :previous
        RangeFromParams.new(period: nil, start_date: (range[0] - (range[1] - range[0])).utc.to_s, end_date: range[0].utc.to_s).build
      elsif type == :year
        RangeFromParams.new(period: nil, start_date: range[0].change(year: range[0].year - 1).utc.to_s, end_date: range[1].change(year: range[1].year - 1).utc.to_s).build
      else
        raise ArgumentError
      end
    end

    def type
      return params[:comparison].to_sym if params[:comparison].in?(VALID_COMPARISONS)
      return :custom if custom_compare?

      nil
    end

    def match_to
      return params[:compare_to].to_sym if params[:compare_to].in?(%w{dow date})

      nil
    end

    def custom_compare
      return nil unless (params[:compare_to_start_date].present? && params[:compare_to_end_date].present?)

      RangeFromParams.new(period: nil, start_date: params[:compare_to_start_date], end_date: params[:compare_to_end_date]).build
    end

    def custom_compare?
      custom_compare
    end
  end
end
