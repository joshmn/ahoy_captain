module AhoyCaptain
  module Stats
    # pls fix
    class AverageViewsPerVisitQuery < ApplicationQuery
      def build
        event_query.joins(:visit)
                              .where(name: "$view")
                              .group("#{AhoyCaptain.visit.table_name}.id")

      end
    end
  end
end
