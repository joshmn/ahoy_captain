module AhoyCaptain
  class EventQuery < ApplicationQuery
    include Rangeable

    def build
      if params[:q]
                 ::Ahoy::Event.ransack(params[:q]).result
               else
                 ::Ahoy::Event.all
               end
    end

    def within_range
      if range
        @query = @query.where("time >= ? and time < ?", range[0], range[1])
      end

      self
    end

    def with_visit
      @query = @query.joins(:visit)

      self
    end
  end
end
