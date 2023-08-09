module AhoyCaptain
  module Stats
    class ViewsPerVisitsController < BaseController
      # @todo: make me a window func
      def index
        @stats = AhoyCaptain::Stats::CountViewsPerVisitQuery.call(params).group_by_period(selected_interval, 'views_per_visit_table.started_at').average(:views_per_visit)
        if range[1]
          (range[0].to_date..range[1].to_date).to_a.each do |date|
            unless @stats.key?(date.to_date)
              @stats[date.to_date] = 2
            end
          end
        end

        @label = "Views"

      end
    end
  end
end
