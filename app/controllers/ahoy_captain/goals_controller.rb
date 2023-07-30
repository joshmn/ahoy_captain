module AhoyCaptain
  class GoalsController < ApplicationController
    def index
      @presenter = GoalsPresenter.new(event_query).build
    end
  end
end
