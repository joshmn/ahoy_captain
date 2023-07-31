module AhoyCaptain
  module Stats
    class BounceRatesQuery < ApplicationQuery
      def build
        visit_query.select("((COUNT(DISTINCT #{AhoyCaptain.visit.table_name}.id) - COUNT(DISTINCT #{AhoyCaptain.event.table_name}.visit_id))::DECIMAL / COUNT(DISTINCT #{AhoyCaptain.visit.table_name}.id)) AS bounce_rate")
      end
    end
  end
end
