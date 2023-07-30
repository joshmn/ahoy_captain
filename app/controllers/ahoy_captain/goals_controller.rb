module AhoyCaptain
  class GoalsController < ApplicationController
    def index
      @goals = 10.times.map {|item| OpenStruct.new(display_name: "Appointment Created", item_amount: 3, total: 5, conversion_rate: 0.02) }
    end
  end
end
