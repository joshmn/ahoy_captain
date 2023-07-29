module AhoyCaptain
  class RealtimesController < ApplicationController
    def show
      @total =::Ahoy::Visit.where(started_at: 1.minute.ago..).count
    end
  end
end
