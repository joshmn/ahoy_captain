module AhoyCaptain
  module Stats
    class TotalPageviewsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::TotalPageviewsQuery.call(params).group_by_period(selected_interval, :time).count
        @label = "Visitors"
      end
    end
  end
end
