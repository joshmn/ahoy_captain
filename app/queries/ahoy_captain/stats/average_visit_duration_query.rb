module AhoyCaptain
  module Stats
    class AverageVisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .reselect("visit_id, max(time) - min(time) as visit_duration")
                   .group("visit_id")

        ::Ahoy::Visit.joins("INNER JOIN #{::AhoyCaptain.event.table_name} ON #{::AhoyCaptain.event.table_name}.visit_id = visit_durations.visit_id")
                   .reselect("avg(visit_duration) as average_visit_duration")
                   .from(events, :visit_durations)
      end
    end
  end
end
