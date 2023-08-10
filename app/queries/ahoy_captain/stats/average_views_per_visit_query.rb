module AhoyCaptain
  module Stats
    # pls fix
    class AverageViewsPerVisitQuery < BaseQuery
      def build
        subquery = event_query.select("count(ahoy_events.visit_id) as count").where(name: "$view")

        AhoyCaptain.event.select("count").from("(#{subquery.to_sql}) as events")
      end

      def self.cast_type(_column)
        nil
      end

      def self.cast_value(_, value)
        value.to_i
      end
    end
  end
end
