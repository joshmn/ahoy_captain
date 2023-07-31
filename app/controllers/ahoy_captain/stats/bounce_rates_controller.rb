module AhoyCaptain
  module Stats
    class BounceRatesController < BaseController
      def index
        @stats = AhoyCaptain::Stats::BounceRatesQuery.call(params).group_by_day("ahoy_visits.started_at")
      end
    end
  end
end
