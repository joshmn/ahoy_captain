module AhoyCaptain
  module Stats
    class ViewsPerVisitsController < BaseController
      include Rangeable

      # @todo: make me a window func
      def index
        @stats = AhoyCaptain::Stats::ViewsPerVisitQuery.call(params).group_by_period(selected_interval, 'views_per_visit_table.started_at').average(:views_per_visit)
        (range[0].to_date..range[1].to_date).to_a.each do |date|
          unless @stats.key?(date.to_date)
            @stats[date.to_date] = 2
          end
        end
      end
    end
  end
end
