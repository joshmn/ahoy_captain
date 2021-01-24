# frozen_string_literal: true

require 'caffeinate/drip_evaluator'
require 'caffeinate/schedule_evaluator'

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
      ::Caffeinate::ScheduleEvaluator.call(self, mailing)
    end

    # Checks if the drip is enabled
    #
    # This is kind of messy and could use some love.
    # todo: better.
    def enabled?(mailing)
      catch(:abort) do
        if dripper.run_callbacks(:before_drip, self, mailing)
          return DripEvaluator.new(mailing).call(&@block)
        else
          return false
        end
      end
      false
    end
  end
end
