module AhoyCaptain
  class StatsController < ApplicationController
    def show
      @presenter = DashboardPresenter.new(params)
    end
  end
end
