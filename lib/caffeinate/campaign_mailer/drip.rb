module Caffeinate
  module CampaignMailer
    # The Drip DSL for registering a drip
    module Drip

      # A collection of Drip objects for a `Caffeinate::CampaignMailer`
      class DripCollection
        include Enumerable

        # @private
        def initialize(campaign_mailer)
          @campaign_mailer = campaign_mailer
          @drips = []
        end

        # @private
        def register(action, options, &block)
          @drips << ::Caffeinate::Drip.new(@campaign_mailer, action, options, &block)
        end

        def each(&block)
          @drips.each { |drip| block.call(drip) }
        end

        def size
          @drips.size
        end
      end

      # @private
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # A collection of Drip objects associated with a given `Caffeinated::CampaignMailer`
        def drips
          @drips ||= DripCollection.new(self)
        end

        # Register a drip on the CampaignMailer
        #
        #   drip :mailer_action_name, mailer_class: "MailerClass", step: 1, delay: 1.hour
        #
        # @param action_name [Symbol] the name of the mailer action
        # @param [Hash] options the options to create a drip with
        # @option options [String] :mailer_class The mailer_class
        # @option options [Integer] :step The order in which the drip is executed
        # @option options [ActiveSupport::Duration] :delay When the drip should be ran
        def drip(action_name, options = {}, &block)
          options.assert_valid_keys(:mailer_class, :step, :delay, :using)
          options[:mailer_class] ||= defaults[:mailer_class]
          options[:step] ||= drips.size + 1

          if options[:delay].nil?
            raise ArgumentError, "delay pls"
          end

          drips.register(action_name, options, &block)
        end
      end
    end
  end
end
