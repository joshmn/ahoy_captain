module AhoyCaptain
  module Stats
    class BounceRatesController < BaseController
      # @todo: this is lazy
      def index
        @stats = AhoyCaptain::Stats::BounceRatesQuery.call(params)
        @stats = lazy_window(@stats.group_by_period(selected_interval, "daily_bounce_rate.date").average("bounce_rate"))
        @label = "Bounce Rate"
      end
    end
  end
end
