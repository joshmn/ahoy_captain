module AhoyCaptain
  class GoalsController < ApplicationController
    def index
      @goals = {}
      AhoyCaptain.configuration.goals.each do |goal|
        @goals[goal.title] = cached(:goal, goal.id) do
          event_query.within_range.where(name: goal.event_name).count
        end
      end

      render json: @goals
    end
  end
end
