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
    def end!(msg)
      mailing.caffeinate_campaign_subscription.end!(msg)
      false
    end

    # Unsubscribes the CampaignSubscription
    def unsubscribe!(msg)
      mailing.caffeinate_campaign_subscription.unsubscribe!(msg)
      false
    end

    # Skips the mailing
    def skip!
      mailing.skip!
      false
    end
  end
end
