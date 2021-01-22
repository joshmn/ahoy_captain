# frozen_string_literal: true

require 'caffeinate/dripper/drip_collection'
module Caffeinate
  module Dripper
    # The Drip DSL for registering a drip.
    module Drip
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # A collection of Drip objects associated with a given `Caffeinate::Dripper`
        def drip_collection
          @drip_collection ||= DripCollection.new(self)
        end

        # A collection of Drip objects associated with a given `Caffeinate::Dripper`
        def drips
          drip_collection.values
        end

        # Register a drip on the Dripper
        #
        #   drip :mailer_action_name, mailer_class: "MailerClass", step: 1, delay: 1.hour
        #
        # @param action_name [Symbol] the name of the mailer action
        # @param [Hash] options the options to create a drip with
        # @option options [String] :mailer_class The mailer_class
        # @option options [Integer] :step The order in which the drip is executed
        # @option options [ActiveSupport::Duration] :delay When the drip should be ran
        # @option options [Block|Symbol|String] :at Alternative to `:delay` option, allowing for more fine-tuned timing.
        # Accepts a block, symbol (an instance method on the Dripper that accepts two arguments: drip, mailing), or a string
        # to be later parsed into a Time object.
        #
        #   drip :mailer_action_name, mailer_class: "MailerClass", at: -> { 3.days.from_now.in_time_zone(mailing.subscriber.timezone) }
        #
        #   class MyDripper
        #     drip :mailer_action_name, mailer_class: "MailerClass", at: :generate_date
        #     def generate_date(drip, mailing)
        #       3.days.from_now.in_time_zone(mailing.subscriber.timezone)
        #     end
        #   end
        #
        #   drip :mailer_action_name, mailer_class: "MailerClass", at: 'January 1, 2022'
        #
        # @option options [Symbol] :using Set to `:parameters` if the mailer action uses ActionMailer::Parameters
        def drip(action_name, options = {}, &block)
          drip_collection.register(action_name, options, &block)
        end
      end
    end
  end
end
