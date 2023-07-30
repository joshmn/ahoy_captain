module AhoyCaptain
  module Stats
    class BounceRatesQuery < ApplicationQuery
      def build
        visit_query.ransack(ransack_params_for(:visit)).result.reselect(
          "(COUNT(ahoy_events.id)::float / COUNT(DISTINCT ahoy_visits.id) / 100) as bounce_rate"
        )
      end
    end
  end
end
