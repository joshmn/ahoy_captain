# frozen_string_literal: true

module Caffeinate
  module Dripper
    # The Drip DSL for registering a drip.
    module Drip
      # A collection of Drip objects for a `Caffeinate::Dripper`
      class DripCollection
        include Enumerable

        def initialize(dripper)
          @dripper = dripper
          @drips = {}
        end

        # Register the drip
        def register(action, options, &block)
          @drips[action.to_s] = ::Caffeinate::Drip.new(@dripper, action, options, &block)
        end

        def each(&block)
          @drips.each { |action_name, drip| block.call(action_name, drip) }
        end

        def values
          @drips.values
        end

        def size
          @drips.size
        end

        def [](val)
          @drips[val]
        end
      end

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
        def drip(action_name, options = {}, &block)
          options.symbolize_keys!
          options.assert_valid_keys(:mailer_class, :step, :delay, :using, :mailer)
          options[:mailer_class] ||= options[:mailer] || defaults[:mailer_class]
          options[:using] ||= defaults[:using]
          options[:step] ||= drips.size + 1

          if options[:mailer_class].nil?
            raise ArgumentError, "You must define :mailer_class or :mailer in the options for :#{action_name}"
          end
          raise ArgumentError, "You must define :delay in the options for :#{action_name}" if options[:delay].nil?

          drip_collection.register(action_name, options, &block)
        end
      end
    end
  end
end
