module AhoyCaptain
  module Stats
    class ViewsPerVisitQuery < ApplicationQuery
      def build
        events = event_query
                   .within_range
                   .with_visit
                   .select("#{::Ahoy::Visit.table_name}.started_at as started_at, count(name) / count(distinct visit_id) as views_per_visit")
                   .where(name: AhoyCaptain.config.view_name)
                   .group("started_at, visit_id")

        visit_query
          .select("views_per_visit as views_per_visit")
          .from(events, :views_per_visit_table)
      end
    end
  end
end
