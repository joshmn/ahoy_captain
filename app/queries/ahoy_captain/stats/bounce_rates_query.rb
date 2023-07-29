module AhoyCaptain
  module Stats
    class BounceRatesQuery < ApplicationQuery
      def build
        visit_query.joins(:events).reselect(
          "(COUNT(ahoy_events.id)::float / COUNT(DISTINCT ahoy_visits.id)) AS bounce_rate"
        )
      end
    end
  end
end
