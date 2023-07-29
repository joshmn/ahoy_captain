module AhoyCaptain
  class EventQuery < ApplicationQuery
    include Rangeable

    def build
      ::Ahoy::Event.ransack(ransack_params).result
    end

    def within_range
      self
    end

    def with_visit
      @query = @query.joins(:visit)

      self
    end

  end
end
