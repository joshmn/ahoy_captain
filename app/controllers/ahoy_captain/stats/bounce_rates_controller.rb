module AhoyCaptain
  module Stats
    class TotalVisitsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::BounceRateQuery.call(params).group_by_day(:started_at).count
      end
    end
  end
end
