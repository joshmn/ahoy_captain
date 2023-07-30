module AhoyCaptain
  module Stats
    class VisitDurationsController < BaseController
      def index
        @stats = AhoyCaptain::Stats::VisitDurationQuery.call(params).group('started_at').average(:duration)
      end
    end
  end
end
