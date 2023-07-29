module AhoyCaptain
  module Stats
    class TotalPageviewsQuery < ApplicationQuery
      def build
        event_query.where(name: AhoyCaptain.config.event[:view_name])
      end
    end
  end
end
