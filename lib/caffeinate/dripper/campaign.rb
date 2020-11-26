# frozen_string_literal: true

module Caffeinate
  module Dripper
    module Campaign
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      # The campaign for this Dripper
      #
      # @return Caffeinate::Campaign
      def campaign
        self.class.caffeinate_campaign
      end

      module ClassMethods
        # Sets the campaign on the Dripper and resets any existing `@caffeinated_campaign`
        #
        #   class OrdersDripper
        #     campaign :order_drip
        #   end
        #
        # If this is not explicitly set, we will infer it with
        #
        #   self.name.delete_suffix("Campaign").underscore
        #
        # @param [Symbol] slug The slug of a persisted `Caffeinate::Campaign`.
        def campaign(slug)
          @caffeinate_campaign = nil
          @_campaign_slug = slug.to_sym
          Caffeinate.register_dripper(@_campaign_slug, name)
        end

        # Returns the `Caffeinate::Campaign` object for the Campaign
        def caffeinate_campaign
          return @caffeinate_campaign if @caffeinate_campaign.present?

          @caffeinate_campaign = ::Caffeinate::Campaign.find_by(slug: campaign_slug)
          return @caffeinate_campaign if @caffeinate_campaign

          raise(::ActiveRecord::RecordNotFound, "Unable to find ::Caffeinate::Campaign with slug #{campaign_slug}.")
        end

        # The defined slug or the inferred slug
        def campaign_slug
          @_campaign_slug || self.name.delete_suffix("Campaign")
        end
      end
    end
  end
end
