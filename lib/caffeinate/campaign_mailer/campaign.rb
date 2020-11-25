# frozen_string_literal: true

module Caffeinate
  module CampaignMailer
    module Campaign
      def self.included(klass)
        klass.extend ClassMethods
      end

      # The campaign for this CampaignMailer
      #
      # @return Caffeinate::Campaign
      def campaign
        self.class.caffeinate_campaign
      end

      module ClassMethods
        # Sets the campaign on the CampaignMailer and resets any existing `@caffeinated_campaign`
        #
        #   class OrdersCampaignMailer
        #     campaign :order_drip
        #   end
        #
        # @param [Symbol] slug The slug of a persisted `Caffeinate::Campaign`
        def campaign(slug)
          @caffeinated_campaign = nil
          @_campaign_slug = slug.to_sym
          Caffeinate.register_campaign_mailer(@_campaign_slug, name)
        end

        # @private
        def caffeinate_campaign
          @caffeinated_campaign ||= ::Caffeinate::Campaign.find_by(slug: campaign_slug)
        end

        # @private
        def campaign_slug
          @_campaign_slug || raise(ArgumentError, 'no defined campaign. Please define it in your campaign mailer')
        end
      end
    end
  end
end
