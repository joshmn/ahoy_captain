module AhoyCaptain
  module Stats
    class AverageVisitDurationQuery < ApplicationQuery
      def build
        max_events = event_query.select("#{AhoyCaptain.event.table_name}.visit_id, max(#{AhoyCaptain.event.table_name}.time) as created_at").group("visit_id")
        visit_query.select("avg((max_events.created_at - #{AhoyCaptain.visit.table_name}.started_at)) as average_visit_duration")
                   .joins("LEFT JOIN (#{max_events.to_sql}) as max_events ON #{AhoyCaptain.visit.table_name}.id = max_events.visit_id")
      end
    end
  end
end
