module AhoyCaptain
  module Stats
    class UniqueVisitorsController < BaseController
      def index
        params[:selected_interval] = selected_interval
        @stats = AhoyCaptain::Stats::Graph::UniqueVisitorsGraphQuery.call(params)
        @label = "Visitors"
      end
    end
  end
end
