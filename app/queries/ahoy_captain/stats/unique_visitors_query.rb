module AhoyCaptain
  module Stats
    class UniqueVisitorsQuery < BaseQuery
      def build
        visit_query.distinct.select(:visitor_token)
      end
    end
  end
end
