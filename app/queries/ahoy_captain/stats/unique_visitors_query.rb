module AhoyCaptain
  module Stats
    class UniqueVisitorsQuery < ApplicationQuery
      include Rangeable

      def build
        ::Ahoy::Visit.where(started_at: range[0]..range[1]).select(:ip)
      end
    end
  end
end
