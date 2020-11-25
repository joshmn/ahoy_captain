module Caffeinate
  module CampaignMailer
    # Handles subscribing records to a campaign.
    module Subscriber
      # @private
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # Runs the subscriber_block
        #
        #   OrderCampaignMailer.subscribe!
        def subscribe!
          subscribing_block.call
        end

        # Returns the campaign's `Caffeinate::CampaignSubscriber`
        def subscribers
          caffeinate_campaign.caffeinate_campaign_subscribers
        end

        # Subscribes to the campaign.
        #
        #   OrderCampaignMailer.subscribe(order, user: order.user)
        #
        # @param [ActiveRecord::Base] subscriber The object subscribing
        # @option [ActiveRecord::Base] :user The associated user (optional)
        #
        # @return [Caffeinate::CampaignSubscriber] the created CampaignSubscriber
        def subscribe(subscriber, user:)
          caffeinate_campaign.subscribe(subscriber, user: user)
        end

        # @private
        def subscribing_block
          raise(NotImplementedError, "Define subscribing") unless @subscribing_block

          @subscribing_block
        end

        # The subscriber block. Used to create `::Caffeinate::CampaignSubscribers` subscribers.
        #
        #   subscribing do
        #     Cart.left_joins(:cart_items)
        #         .includes(:user)
        #         .where(completed_at: nil)
        #         .where(updated_at: 1.day.ago..2.days.ago)
        #         .having('count(cart_items.id) = 0').each do |cart|
        #       subscribe(cart, user: cart.user)
        #     end
        #   end
        #
        # No need to worry about checking if the given subscriber being already subscribed.
        # The `subscribe` method does that for you.
        def subscribing(&block)
          @subscribing_block = block
        end
      end
    end
  end
end
