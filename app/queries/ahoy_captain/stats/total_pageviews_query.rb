module AhoyCaptain
  module Stats
    class TotalPageviewsQuery < ApplicationQuery
      def build
        event_query.within_range.where(name: AhoyCaptain.config.view_name)
      end
    end
  end
end
