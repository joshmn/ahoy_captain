module AhoyCaptain
  module Stats
    class TotalPageviewsQuery < ApplicationQuery
      def build
        event_query.where(name: AhoyCaptain.config.view_name)
      end
    end
  end
end
