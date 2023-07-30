module AhoyCaptain
  class FunnelsController < ApplicationController
    def show
      funnel = AhoyCaptain.configuration.funnels[params[:id]]
      @funnel = FunnelPresenter.new(funnel, event_query).build
    end
  end
end
