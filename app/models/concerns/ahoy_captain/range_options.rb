module AhoyCaptain
  module RangeOptions

    private def range
      if params[:start_date].present? && params[:end_date].present?
        custom = [params[:start_date].to_datetime, params[:end_date].to_datetime].sort
        duration = (custom[1].to_date -  custom[0].to_date)

        if AhoyCaptain.config.ranges.max && (duration.days <= AhoyCaptain.config.ranges.max)
          return custom
        end
      end

      AhoyCaptain.config.ranges.for(period)
    end
  end
end
