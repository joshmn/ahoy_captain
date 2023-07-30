module AhoyCaptain
  class VisitQuery < ApplicationQuery
    include Rangeable

    def build
      ::Ahoy::Visit.ransack(ransack_params_for(:visit)).result
    end

    def within_range
      if range
        @query = @query.where('started_at >= ? and started_at < ?', range[0], range[1])
      end

      self
    end

    def with_events
      @query = @query.joins(:events)

      self
    end

    def is_a?(other)
      if other == ActiveRecord::Relation
        return true
      end

      super(other)
    end
  end
end
