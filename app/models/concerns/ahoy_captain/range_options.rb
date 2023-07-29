module AhoyCaptain
  module RangeOptions

    def period
      raise NotImplementedError
    end

    private def range
      if params[:start_date] && params[:end_date]
        [params[:start_date].to_date, params[:end_date].to_date]
      else
        AhoyCaptain.config.ranges.for(period)
      end
    end
  end
end
