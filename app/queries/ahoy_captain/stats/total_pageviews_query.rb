module AhoyCaptain
  module Stats
    class TotalPageviewsQuery < BaseQuery
      def build
        event_query.page_view
      end
    end
  end
end
