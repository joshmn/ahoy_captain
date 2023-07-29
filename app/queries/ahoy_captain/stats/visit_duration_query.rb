module AhoyCaptain
  module Stats
    class VisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .with_visit
                   .select("#{::AhoyCaptain.visit_name}.started_at as started_at, visit_id, max(time) - min(time) as visit_duration")
                   .group("started_at, visit_id")

        visit_query
                   .reselect("started_at, visit_duration as visit_duration")
                   .from(events, :visit_durations)
      end
    end
  end
end
