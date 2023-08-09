module AhoyCaptain
  module Stats
    class CountViewsPerVisitQuery < ApplicationQuery
      def build
        events = event_query
                   .joins(:visit)
                   .select("#{::AhoyCaptain.visit.table_name}.started_at as started_at, count(#{AhoyCaptain.event.table_name}.name) / count(distinct #{AhoyCaptain.event.table_name}.visit_id) as views_per_visit")
                   .where(name: AhoyCaptain.config.event[:view_name])
                   .group("#{AhoyCaptain.visit.table_name}.started_at, #{AhoyCaptain.event.table_name}.visit_id")

        ::Ahoy::Visit
                     .select("views_per_visit as views_per_visit")
                     .from(events, :views_per_visit_table)
      end
    end
  end
end
