module AhoyCaptain
  module Stats
    class AverageViewsPerVisitQuery < ApplicationQuery
      def build
        events = event_query
                   .select("count(name) / count(distinct visit_id) as views_per_visit")
                   .where(name: AhoyCaptain.config.view_name)
                   .group("visit_id")

        visit_query
          .select("avg(views_per_visit) as average_views_per_visit")
          .from(events, :views_per_visit_table)

      end
    end
  end
end
