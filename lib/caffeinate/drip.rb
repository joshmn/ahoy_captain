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

    def send_at
      options[:delay].from_now
    end

    # Checks if the drip is enabled
    def enabled?(mailing)
      DripEvaluator.new(mailing).call(&@block)
    end
  end
end
