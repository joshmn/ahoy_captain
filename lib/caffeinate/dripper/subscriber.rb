# frozen_string_literal: true

module Caffeinate
  module Dripper
    # Handles subscribing records to a campaign.
    module Subscriber
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # Returns the Campaign's `Caffeinate::CampaignSubscriber`
        def subscriptions
          caffeinate_campaign.caffeinate_campaign_subscriptions
        end

        # Subscribes to the campaign.
        #
        #   OrderDripper.subscribe(order, user: order.user)
        #
        # @param [ActiveRecord::Base] subscriber The object subscribing
        # @option [ActiveRecord::Base] :user The associated user (optional)
        #
        # @return [Caffeinate::CampaignSubscriber] the created CampaignSubscriber
        def subscribe(subscriber, **args)
          caffeinate_campaign.subscribe!(subscriber, **args)
        end

        # Unsubscribes from the campaign. Returns false if something's wrong.
        #
        #   OrderDripper.unsubscribe(order, user: order.user)
        #
        # @param [ActiveRecord::Base] subscriber The object subscribing
        # @option [ActiveRecord::Base] :user The associated user (optional)
        #
        # @return [Caffeinate::CampaignSubscriber] the CampaignSubscriber
        def unsubscribe(subscriber, **args)
          caffeinate_campaign.unsubscribe(subscriber, **args)
        end

        # Unsubscribes from the campaign. Raises error if somerthing's wrong.
        #
        #   OrderDripper.unsubscribe(order, user: order.user)
        #
        # @param [ActiveRecord::Base] subscriber The object subscribing
        # @option [ActiveRecord::Base] :user The associated user (optional)
        #
        # @return [Caffeinate::CampaignSubscriber] the CampaignSubscriber
        def unsubscribe!(subscriber, **args)
          caffeinate_campaign.unsubscribe!(subscriber, **args)
        end
      end
    end
  end
end
