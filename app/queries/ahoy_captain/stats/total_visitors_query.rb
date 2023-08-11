module AhoyCaptain
  module Stats
    class TotalVisitorsQuery < BaseQuery
      def build
        visit_query.distinct.select(:id)
      end
    end
  end
end
