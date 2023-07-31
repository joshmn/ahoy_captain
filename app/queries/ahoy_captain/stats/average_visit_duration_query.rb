module AhoyCaptain
  module Stats
    class AverageVisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .reselect("ahoy_events.visit_id, max(ahoy_events.time) - min(ahoy_events.time) as visit_duration")
                   .group("visit_id")

        ::Ahoy::Visit.joins("INNER JOIN #{::AhoyCaptain.event.table_name} ON #{::AhoyCaptain.event.table_name}.visit_id = visit_durations.visit_id")
                   .reselect("avg(visit_duration) as average_visit_duration")
                   .from(events, :visit_durations)
      end
    end
  end
end
