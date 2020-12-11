# frozen_string_literal: true

module Caffeinate
  module Dripper
    # A collection of Drip objects for a `Caffeinate::Dripper`
    class DripCollection
      include Enumerable

      def initialize(dripper)
        @dripper = dripper
        @drips = {}
      end

      def for(action)
        @drips[action.to_sym]
      end

      # Register the drip
      def register(action, options, &block)
        options = validate_drip_options(action, options)

        @drips[action.to_sym] = ::Caffeinate::Drip.new(@dripper, action, options, &block)
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

      private

      def validate_drip_options(action, options)
        options.symbolize_keys!
        options.assert_valid_keys(:mailer_class, :step, :delay, :every, :start, :using, :mailer)
        options[:mailer_class] ||= options[:mailer] || @dripper.defaults[:mailer_class]
        options[:using] ||= @dripper.defaults[:using]
        options[:step] ||= @dripper.drips.size + 1

        if options[:mailer_class].nil?
          raise ArgumentError, "You must define :mailer_class or :mailer in the options for #{action.inspect} on #{@dripper.inspect}"
        end

        if options[:every].nil? && options[:delay].nil?
          raise ArgumentError, "You must define :delay in the options for #{action.inspect} on #{@dripper.inspect}"
        end

        options
      end
    end
  end
end
