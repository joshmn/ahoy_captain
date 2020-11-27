# frozen_string_literal: true

module Caffeinate
  class CampaignSubscriptionsController < ApplicationController
    before_action :find_campaign_subscription!

    def unsubscribe
      @campaign_subscription.unsubscribe!
      render plain: 'You have been unsubscribed.'
    end

    private

    def find_campaign_subscription!
      @campaign_subscription = ::Caffeinate::CampaignSubscription.find_by(token: params[:token])
      return render plain: '404' if @campaign_subscription.nil?
    end
  end
end
