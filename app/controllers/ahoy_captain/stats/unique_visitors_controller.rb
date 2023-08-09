module AhoyCaptain
  module Stats
    class UniqueVisitorsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::UniqueVisitorsQuery.call(params).with_window.count("distinct ahoy_visits.visitor_token")
        @label = "Visitors"
      end
    end
  end
end
