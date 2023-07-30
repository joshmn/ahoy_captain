module AhoyCaptain
  module RangeOptions

    def period
      raise NotImplementedError
    end

    private def range
      if params[:start_date] && params[:end_date]
        [params[:start_date].to_datetime, params[:end_date].to_datetime]
      else
        AhoyCaptain.config.ranges.for(period)
      end
    end
  end
end
