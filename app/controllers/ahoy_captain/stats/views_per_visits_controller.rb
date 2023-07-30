module AhoyCaptain
  module Stats
    class ViewsPerVisitsController < BaseController
      include Rangeable

      def index
        @stats = AhoyCaptain::Stats::ViewsPerVisitQuery.call(params).group_by_day('views_per_visit_table.started_at').average(:views_per_visit)
        (range[0]..range[1]).to_a.each do |date|
          unless @stats.key?(date.to_date)
            @stats[date.to_date] = 2
          end
        end
      end
    end
  end
end
