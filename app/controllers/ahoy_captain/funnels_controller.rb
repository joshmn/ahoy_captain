module AhoyCaptain
  class FunnelsController < ApplicationController
    def index
      @funnels = {}
      AhoyCaptain.configuration.funnels.each do |funnel|
        @funnels[funnel.label] = FunnelPresenter.new(funnel, event_query).build
      end

      abort
    end

    def show
      funnel = AhoyCaptain.configuration.funnels["Appointments"]
      @funnel = FunnelPresenter.new(funnel, event_query).build
    end
  end
end
