module AhoyCaptain
  module Strategies
    class Base
      def initialize(event_query)
        @event_query = event_query
      end

      def build_total_query(table_name)
        raise NotImplementedError
      end

      def build_goal_query(table_name, goal_id, index)
        raise NotImplementedError
      end
    end
  end
end