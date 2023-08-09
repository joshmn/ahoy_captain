module AhoyCaptain
  module Stats
    class ViewsPerVisitsController < BaseController
      def index
        @stats = lazy_window(AhoyCaptain::Stats::ViewsPerVisitQuery.call(params).group_by_period(selected_interval, 'views_per_visit_table.started_at').average(:views_per_visit))

        @label = "Views"
      end
    end
  end
end
