module AhoyCaptain
  module Stats
    class BounceRatesQuery < ApplicationQuery
      def build
        visit_query.within_range.select(
          "(COUNT(ahoy_events.id)::float / COUNT(DISTINCT ahoy_visits.id) * 100) AS bounce_rate"
        ).left_joins(:events).where(ahoy_events: { id: nil })
      end
    end
  end
end
