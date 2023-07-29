module AhoyCaptain
  module Stats
    class AverageVisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .within_range
                   .reselect("visit_id, max(time) - min(time) as visit_duration")
                   .group("visit_id")

        visit_query.joins("INNER JOIN #{::Ahoy::Event.table_name} ON #{::Ahoy::Event.table_name}.visit_id = visit_durations.visit_id")
                   .reselect("avg(visit_duration) as average_visit_duration")
                   .from(events, :visit_durations)
      end
    end
  end
end
