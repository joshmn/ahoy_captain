module AhoyCaptain
  module Stats
    class VisitDurationsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::VisitDurationQuery.call(params).group_by_day('ahoy_visits.started_at').average(:visit_duration)
      end
    end
  end
end
