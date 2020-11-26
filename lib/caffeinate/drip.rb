# frozen_string_literal: true

module Caffeinate
  # A Drip object
  class Drip
    # Handles the block and provides convenience methods for the drip
    class Evaluator
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

    attr_reader :campaign_mailer, :action, :options, :block
    def initialize(campaign_mailer, action, options, &block)
      @campaign_mailer = campaign_mailer
      @action = action
      @options = options
      @block = block
    end

    # If the associated ActionMailer uses `ActionMailer::Parameterized` initialization
    def parameterized?
      options[:using] == :parameterized
    end

    # If the drip is enabled.
    def enabled?(mailing)
      Evaluator.new(mailing).call(&@block)
    end
  end
end
