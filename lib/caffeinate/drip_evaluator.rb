# frozen_string_literal: true

module Caffeinate
  # Handles evaluating the `drip` block and provides convenience methods for handling the mailing or its campaign.
  class DripEvaluator
    attr_reader :mailing

    def initialize(mailing)
      @mailing = mailing
    end

    def call(&block)
      return true unless block

      instance_eval(&block)
    end

    # Ends the CampaignSubscription
    def end!
      mailing.caffeinate_campaign_subscription.end!
      false
    end

    # Unsubscribes the CampaignSubscription
    def unsubscribe!
      mailing.caffeinate_campaign_subscription.unsubscribe!
      false
    end

    # Skips the mailing
    def skip!
      mailing.skip!
      false
    end
  end
end
