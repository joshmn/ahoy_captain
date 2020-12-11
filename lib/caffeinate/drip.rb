# frozen_string_literal: true

require 'caffeinate/drip_evaluator'
module Caffeinate
  # A Drip object
  #
  # Handles the block and provides convenience methods for the drip
  class Drip
    attr_reader :dripper, :action, :options, :block

    def initialize(dripper, action, options, &block)
      @dripper = dripper
      @action = action
      @options = options
      @block = block
    end

    # If the associated ActionMailer uses `ActionMailer::Parameterized` initialization instead of argument-based initialization
    def parameterized?
      options[:using] == :parameterized
    end

    def send_at(mailing = nil)
      if periodical?
        start = mailing.instance_exec(&options[:start])
        start += options[:every] if mailing.caffeinate_campaign_subscription.caffeinate_mailings.count.positive?
        start.from_now
      else
        options[:delay].from_now
      end
    end

    def periodical?
      options[:every].present?
    end

    # Checks if the drip is enabled
    def enabled?(mailing)
      dripper.run_callbacks(:before_drip, self, mailing)

      DripEvaluator.new(mailing).call(&@block)
    end
  end
end
