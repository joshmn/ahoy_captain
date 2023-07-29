module AhoyCaptain
  module Stats
    class TotalVisitorsQuery < ApplicationQuery
      def build
        visit_query.within_range
      end
    end
  end
end
