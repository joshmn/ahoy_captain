module AhoyCaptain
  module Stats
    class TotalPageviewsController < BaseController
      def index
        @stats = lazy_window(AhoyCaptain::Stats::TotalPageviewsQuery.call(params).group_by_period(selected_interval, :time).count, 0)
        @label = "Visitors"
      end
    end
  end
end
