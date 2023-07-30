module AhoyCaptain
  module Stats
    class BounceRatesQuery < ApplicationQuery
      def build
        a = visit_query.ransack(ransack_params).result.reselect(
          "COUNT(ahoy_events.id)::float / COUNT(DISTINCT ahoy_visits.id) as bounce_rate"
        )
      end
    end
  end
end
