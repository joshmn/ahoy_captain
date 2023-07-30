module AhoyCaptain
  module Stats
    class BounceRatesController < BaseController
      def index
        @stats = AhoyCaptain::Stats::BounceRatesQuery.call(params).group_by_day("ahoy_visits.started_at").average("num_events")
        #.group_by_day("ahoy_visits.started_at").average("total_events")
      end
    end
  end
end
