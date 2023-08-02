module AhoyCaptain
  module Stats
    class VisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .select("max(#{AhoyCaptain.event.table_name}.time) - min(#{AhoyCaptain.event.table_name}.time) as duration, #{AhoyCaptain.event.table_name}.visit_id")
                   .group("visit_id")

        ::Ahoy::Visit
          .joins("inner join #{AhoyCaptain.event.table_name} on ahoy_visits.id = views_per_visit_table.visit_id")
          .select("duration as duration, ahoy_visits.started_at")
          .from(events, :views_per_visit_table)
      end
    end
  end
end
