# frozen_string_literal: true

require 'caffeinate/drip_evaluator'
module Caffeinate
  # A Drip object
  #
  # Handles the block and provides convenience methods for the drip
  class Drip
    class OptionEvaluator
      def initialize(thing, drip, mailing)
        @thing = thing
        @drip = drip
        @mailing = mailing
      end

      def call
        if @thing.is_a?(Symbol)
          @drip.dripper.new.send(@thing, @drip, @mailing)
        elsif @thing.is_a?(Proc)
          @mailing.instance_exec(&@thing)
        elsif @thing.is_a?(String)
          Time.parse(@thing)
        else
          @thing
        end
      end
    end

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
        date = start.from_now
      elsif options[:on]
        date = OptionEvaluator.new(options[:on], self, mailing).call
      else
        date = OptionEvaluator.new(options[:delay], self, mailing).call
        if date.respond_to?(:from_now)
          date = date.from_now
        end
      end

      if options[:at]
        time = OptionEvaluator.new(options[:at], self, mailing).call
        return date.change(hour: time.hour, min: time.min, sec: time.sec)
      end

      date
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
