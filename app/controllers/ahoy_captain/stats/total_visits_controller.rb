module AhoyCaptain
  module Stats
    class TotalVisitsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::TotalVisitorsQuery.call(params).group_by_period(selected_interval, :started_at).count
        @label = "Visitors"
      end
    end
  end
end
