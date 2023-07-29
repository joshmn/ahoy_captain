module AhoyCaptain
  module Stats
    class TotalVisitorsQuery < ApplicationQuery
      def build
        visit_query.all
      end
    end
  end
end
