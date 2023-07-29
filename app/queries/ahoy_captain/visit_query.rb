module AhoyCaptain
  class VisitQuery < ApplicationQuery
    include Rangeable

    def build
      if params[:q]
                 ::Ahoy::Visit.ransack(params[:q]).result
               else
                 ::Ahoy::Visit.all
               end
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
  end
end
