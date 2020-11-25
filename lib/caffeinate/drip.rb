# frozen_string_literal: true

module Caffeinate
  # A Drip object
  class Drip
    class Evaluator
      attr_reader :mailing
      def initialize(mailing)
        @mailing = mailing
      end

      def call(&block)
        return true unless block

        instance_eval(&block)
      end

      # Ends the mailing.
      def end!
        mailing.caffeinate_campaign_subscription.end!
        false
      end

      def unsubscribe!
        mailing.caffeinate_campaign_subscription.unsubscribe!
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

    def parameterized?
      options[:using] == :parameterized
    end

    def enabled?(mailing)
      Evaluator.new(mailing).call(&@block)
    end
  end
end
