# frozen_string_literal: true

module Caffeinate
  module Dripper
    module Defaults
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # The defaults set in the Campaign
        def defaults
          @defaults ||= { mailer_class: inferred_mailer_class }
        end

        # The default options for the Campaign
        #
        #   class OrderCampaign
        #     default mailer_class: "OrdersMailer"
        #   end
        #
        # @param [Hash] options The options to set defaults with
        # @option options [String] :mailer_class The mailer class
        def default(options = {})
          options.assert_valid_keys(:mailer_class, :mailer, :using)
          @defaults = options
        end
      end
    end
  end
end
