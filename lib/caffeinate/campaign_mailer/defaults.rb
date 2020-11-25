module Caffeinate
  module CampaignMailer
    module Defaults
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # The defaults set in the CampaignMailer
        def defaults
          @defaults || {}
        end

        # The default options for the CampaignMailer
        #
        #   class OrderCampaignMailer
        #     default mailer_class: "OrdersMailer"
        #   end
        #
        # @param [Hash] options The options to set defaults with
        # @option options [String] :mailer_class The mailer class
        def default(options = {})
          options.assert_valid_keys(:mailer_class)
          @defaults = options
        end
      end
    end
  end
end
