module AhoyCaptain
  module Stats
    class VisitDurationQuery < ApplicationQuery
      def build
        events = event_query
                   .reselect("max(#{AhoyCaptain.event.table_name}.time) - min(#{AhoyCaptain.event.table_name}.time) as duration, #{AhoyCaptain.event.table_name}.visit_id")
                   .group("#{AhoyCaptain.event.table_name}.visit_id")

        ::Ahoy::Visit
          .select("duration as duration, started_at")
          .from(events, :views_per_visit_table)
          .joins("inner join #{AhoyCaptain.visit.table_name} on #{AhoyCaptain.visit.table_name}.id = views_per_visit_table.visit_id")
      end
    end
  end
end
