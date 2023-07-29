module AhoyCaptain
  module Stats
    class UniqueVisitorsQuery < ApplicationQuery
      def build
        visit_query.distinct(:ip)
      end
    end
  end
end
