module AhoyCaptain
  module Stats
    class VisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .select("max(time) - min(time) as duration, visit_id")
                   .group("visit_id")

        ::Ahoy::Visit
          .joins("inner join ahoy_visits on ahoy_visits.id = views_per_visit_table.visit_id")
          .select("duration as duration, ahoy_visits.started_at")
          .from(events, :views_per_visit_table)
      end
    end
  end
end
