module AhoyCaptain
  module Strategies
    class TotalEvents < Base
      def build_total_query(table_name)
        @event_query.select(
          "count(distinct(#{table_name}.user_id)) as unique_visits, 
           '_internal_total_visits_' as name, 
           count(distinct #{table_name}.id) as total_events, 
           0 as sort_order"
        )
      end

      def build_goal_query(table_name, goal_id, index)
        @event_query.select(
          "count(distinct(#{table_name}.user_id)) as unique_visits, 
           '#{goal_id}' as name, 
           count(distinct #{table_name}.id) as total_events, 
           #{index + 1} as sort_order"
        )
      end
    end
  end
end