module AhoyCaptain
  class RealtimesController < ApplicationController
    def show
      @total = event_query.where('ahoy_events.time > ?', 1.minute.ago).distinct(:visit_id).count(:visit_id)
    end
  end
end
