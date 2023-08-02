module AhoyCaptain
  module Stats
    class TotalVisitorsQuery < ApplicationQuery
      def build
        visit_query.distinct.select(:id)
      end
    end
  end
end
