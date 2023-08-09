module AhoyCaptain
  module Stats
    class UniqueVisitorsController < BaseController
      def index
        @stats = lazy_window(AhoyCaptain::Stats::UniqueVisitorsQuery.call(params).group_by_period(selected_interval, :started_at).count)
        @label = "Visitors"
      end
    end
  end
end
