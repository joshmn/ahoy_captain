module AhoyCaptain
  module Stats
    class TotalVisitorsQuery < ApplicationQuery
      def build
        visit_query.distinct(:visit_id)
      end
    end
  end
end
