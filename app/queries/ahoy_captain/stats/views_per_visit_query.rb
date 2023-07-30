module AhoyCaptain
  module Stats
    class ViewsPerVisitQuery < ApplicationQuery
      def build
        events = event_query
                   .joins(:visit)
                   .select("#{::AhoyCaptain.visit.table_name}.started_at as started_at, count(name) / count(distinct visit_id) as views_per_visit")
                   .where(name: AhoyCaptain.config.event[:view_name])
                   .group("started_at, visit_id")

        ::Ahoy::Visit.ransack(ransack_params).result
                     .select("views_per_visit as views_per_visit")
                     .from(events, :views_per_visit_table)
      end
    end
  end
end
