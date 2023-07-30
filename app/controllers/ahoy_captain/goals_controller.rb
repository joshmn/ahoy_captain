module AhoyCaptain
  class GoalsController < ApplicationController
    def index
      @goals = [
        OpenStruct.new(name: "Appointment Created", uniques: 3, total: 5, conversion_rate: 0.02)
      ]

    end
  end
end
