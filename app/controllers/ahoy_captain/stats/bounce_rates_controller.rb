module AhoyCaptain
  module Stats
    class BounceRatesController < BaseController
      def index
        @stats = AhoyCaptain::Stats::BounceRatesQuery.call(params).group_by_day(:started_at).count("*")
      end
    end
  end
end
