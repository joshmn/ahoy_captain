# frozen_string_literal: true

module Caffeinate
  class CampaignSubscriptionsController < ApplicationController
    layout '_caffeinate'

    helper_method :caffeinate_unsubscribe_url, :caffeinate_subscribe_url

    before_action :find_campaign_subscription!

    def unsubscribe
      @campaign_subscription.unsubscribe!
    end

    def subscribe
      @campaign_subscription.resubscribe!
    end

    private

    def caffeinate_subscribe_url(**options)
      Caffeinate::UrlHelpers.caffeinate_subscribe_url(@campaign_subscription, options)
    end

    def caffeinate_unsubscribe_url(**options)
      Caffeinate::UrlHelpers.caffeinate_unsubscribe_url(@campaign_subscription, options)
    end

    def find_campaign_subscription!
      @campaign_subscription = ::Caffeinate::CampaignSubscription.find_by(token: params[:token])
      raise ::ActiveRecord::RecordNotFound if @campaign_subscription.nil?
    end
  end
end
