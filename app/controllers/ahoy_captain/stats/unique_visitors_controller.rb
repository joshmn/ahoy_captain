module AhoyCaptain
  module Stats
    class UniqueVisitorsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::UniqueVisitorsQuery.call(params).group_by_day(:started_at).count
      end
    end
  end
end
