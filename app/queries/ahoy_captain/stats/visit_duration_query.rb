module AhoyCaptain
  module Stats
    class VisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .reselect("visit_id, max(time) - min(time) as visit_duration")
                   .group("visit_id")
        ::Ahoy::Visit.joins("INNER JOIN #{::AhoyCaptain.visit.table_name} ON #{::AhoyCaptain.visit.table_name}.id = visit_durations.visit_id")
                                .reselect("started_at, avg(visit_durations.visit_duration) as average_visit_duration")
                                .from(events, :visit_durations)

      end
    end
  end
end
