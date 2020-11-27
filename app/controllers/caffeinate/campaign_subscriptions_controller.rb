# frozen_string_literal: true

module Caffeinate
  class CampaignSubscriptionsController < ApplicationController
    layout 'caffeinate'

    helper_method :caffeinate_unsubscribe_url, :caffeinate_subscribe_url

    before_action :find_campaign_subscription!

    def unsubscribe
      @campaign_subscription.unsubscribe!
    end

    def subscribe
      @campaign_subscription.subscribe!
    end

    private

    def caffeinate_subscribe_url
      Caffeinate::Engine.routes.url_helpers.subscribe_campaign_subscription_url(token: @campaign_subscription.token, **Rails.application.routes.default_url_options)
    end

    def caffeinate_unsubscribe_url
      Caffeinate::Engine.routes.url_helpers.unsubscribe_campaign_subscription_url(token: @campaign_subscription.token, **Rails.application.routes.default_url_options)
    end

    def find_campaign_subscription!
      @campaign_subscription = ::Caffeinate::CampaignSubscription.find_by(token: params[:token])
      raise ::ActiveRecord::RecordNotFound if @campaign_subscription.nil?
    end
  end
end
