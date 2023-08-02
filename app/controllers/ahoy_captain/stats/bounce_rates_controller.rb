module AhoyCaptain
  module Stats
    class BounceRatesController < BaseController
      # @todo: this is lazy
      def index
        @stats = AhoyCaptain::Stats::BounceRatesQuery.call(params)
        @stats = @stats.group_by_day("daily_bounce_rate.date").average("bounce_rate")
      end
    end
  end
end
