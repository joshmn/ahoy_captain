module AhoyCaptain
  module Stats
    class ViewsPerVisitsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::ViewsPerVisitQuery.call(params).group_by_day('views_per_visit_table.started_at').average(:views_per_visit)
      end
    end
  end
end
