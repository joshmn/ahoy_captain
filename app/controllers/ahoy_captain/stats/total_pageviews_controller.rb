module AhoyCaptain
  module Stats
    class TotalPageviewsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::TotalPageviewsQuery.call(params).group_by_day(:time).count
      end
    end
  end
end
