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
      catch(:abort) do
        result = instance_eval(&block)
        return result.nil? || result === true
      end
      false
    end

    # Ends the CampaignSubscription
    def end!(*args)
      mailing.caffeinate_campaign_subscription.end!(*args)
      throw(:abort)
    end

    # Unsubscribes the CampaignSubscription
    def unsubscribe!(*args)
      mailing.caffeinate_campaign_subscription.unsubscribe!(*args)
      throw(:abort)
    end

    # Skips the mailing
    def skip!
      mailing.skip!
      throw(:abort)
    end
  end
end
