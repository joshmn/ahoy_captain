module AhoyCaptain
  module Stats
    class VisitDurationQuery < ApplicationQuery
      def build
        events = event_query
          .joins(:visit)
                   .reselect("ahoy_visits.started_at as started_at, visit_id, max(time) - min(time) as visit_duration")
                   .group("visit_id")

        ::Ahoy::Visit.joins("INNER JOIN #{::AhoyCaptain.event.table_name} ON #{::AhoyCaptain.event.table_name}.visit_id = visit_durations.visit_id")
                     .reselect("started_at, avg(visit_duration) as average_visit_duration")
                     .from(events, :visit_durations)

      end
    end
  end
end
