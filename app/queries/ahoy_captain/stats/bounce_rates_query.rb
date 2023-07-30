module AhoyCaptain
  module Stats
    class BounceRatesQuery < ApplicationQuery
      def build
        ab = event_query.select("visit_id", "count(*) as num_events").group("visit_id")
        ::Ahoy::Event.with(visit_counts: ab)
                         .joins("inner join ahoy_events on ahoy_events.visit_id = visit_counts.visit_id ")
                         .joins(:visit)
                         .select("(COUNT(CASE WHEN num_events = 1 THEN 1 ELSE NULL END)::numeric / COUNT(*)) * 100 AS bounce_rate")
                         .from("visit_counts")
      end
    end
  end
end
