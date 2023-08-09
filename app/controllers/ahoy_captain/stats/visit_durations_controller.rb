module AhoyCaptain
  module Stats
    class VisitDurationsController < BaseController
      def index
        @stats = lazy_window(AhoyCaptain::Stats::VisitDurationQuery.call(params).group_by_period(selected_interval, 'started_at').average(:duration))
        @label = "Duration"
      end
    end
  end
end
