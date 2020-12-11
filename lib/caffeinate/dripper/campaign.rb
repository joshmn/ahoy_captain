# frozen_string_literal: true

module Caffeinate
  module Dripper
    # Campaign methods for `Caffeinate::Dripper`.
    module Campaign
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      # The campaign for this Dripper
      #
      # @return `Caffeinate::Campaign`
      def campaign
        self.class.caffeinate_campaign
      end

      module ClassMethods
        # Sets the campaign on the Dripper and resets any existing `@caffeinate_campaign`
        #
        #   class OrdersDripper < ApplicationDripper
        #     campaign :order_drip
        #   end
        #
        # If this is not explicitly set, we will infer it with
        #
        #   self.name.delete_suffix("Campaign").underscore
        #
        # @param [Symbol] slug The slug of a persisted `Caffeinate::Campaign`.
        def campaign=(slug)
          @caffeinate_campaign = nil
          @_campaign_slug = slug.to_sym
          Caffeinate.dripper_collection.register(@_campaign_slug, name)
        end

        # Returns the `Caffeinate::Campaign` object for the Dripper.
        #
        # If `config.implicit_campaigns` is true, this will automatically create a `Caffeinate::Campaign` if one is not
        # found via the `campaign_slug`.
        def caffeinate_campaign
          return @caffeinate_campaign if @caffeinate_campaign.present?

          if ::Caffeinate.config.implicit_campaigns?
            @caffeinate_campaign = ::Caffeinate::Campaign.find_or_initialize_by(slug: campaign_slug)
            if @caffeinate_campaign.new_record?
              @caffeinate_campaign.name = "#{name.delete_suffix('Dripper').titleize} Campaign"
              @caffeinate_campaign.save!
            end
          else
            @caffeinate_campaign = ::Caffeinate::Campaign[campaign_slug]
          end

          @caffeinate_campaign
        end
        alias campaign caffeinate_campaign

        # The defined slug or the inferred slug
        def campaign_slug
          @_campaign_slug || inferred_campaign_slug
        end
      end
    end
  end
end
