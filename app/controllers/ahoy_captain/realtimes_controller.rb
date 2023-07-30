module AhoyCaptain
  class RealtimesController < ApplicationController
    def show
      @total = visit_query.where('started_at > ?', 1.minute.ago).distinct(:id).count
    end
  end
end
