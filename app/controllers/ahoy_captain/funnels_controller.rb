module AhoyCaptain
  class FunnelsController < ApplicationController
    def index
      @funnels = {}
      AhoyCaptain.configuration.funnels.each do |funnel|
        @funnels[funnel.label] = cached(:funnels, funnel.label) do
          query = visit_query.with_events
          funnel.goals.each do |goal|
            query = query.where(ahoy_events: { name: goal })
          end
          query.count
        end
      end

      render json: @funnels
    end
  end
end
