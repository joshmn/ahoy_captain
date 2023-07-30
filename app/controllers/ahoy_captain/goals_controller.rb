module AhoyCaptain
  class GoalsController < ApplicationController
    def index
      @goals = {}
      AhoyCaptain.configuration.goals.each do |goal|
        @goals[goal.title] = cached(:goal, goal.id) do
          event_query.where(name: goal.event_name).count
        end
      end
    end
  end
end
