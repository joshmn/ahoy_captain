module AhoyCaptain
  module Filters
    class GoalsController < BaseController
      def index
        render json: AhoyCaptain.configuration.goals.map { |goal| { text: goal.title, value: goal.id } }
      end
    end
  end
end
