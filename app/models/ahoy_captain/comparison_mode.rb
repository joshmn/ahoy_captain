module AhoyCaptain
  class ComparisonMode
    include RangeOptions
    include Rangeable

    attr_reader :params
    def initialize(params)
      @params = params
    end

    # can't compare realtime
    def enabled?
      params[:comparison] == 'true' && range[1]
    end

    def label
      "Previous period"
    end

    def compared_to_range
      [range[0] - (range[1] - range[0]), range[0]]
    end
  end
end
