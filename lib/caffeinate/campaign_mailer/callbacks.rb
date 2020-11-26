# frozen_string_literal: true

module Caffeinate
  module CampaignMailer
    module Callbacks
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # :nodoc:
        def run_callbacks(name, *args)
          send("#{name}_blocks").each do |callback|
            callback.call(*args)
          end
        end

        # Callback after a Caffeinate::CampaignSubscription is created, and after the Caffeinated::Mailings have
        # been created.
        #
        #   on_subscribe do |campaign_subscription|
        #     Slack.notify(:caffeinated, "A new subscriber to #{campaign_subscription.campaign.name}!")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        def on_subscribe(&block)
          on_subscribe_blocks << block
        end

        # :nodoc:
        def on_subscribe_blocks
          @on_subscribe_blocks ||= []
        end

        # Callback before a Mailing has been sent.
        #
        #   before_send do |campaign_subscription, mailing, message|
        #     Slack.notify(:caffeinated, "A new subscriber to #{campaign_subscription.campaign.name}!")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        # @yield Caffeinate::Mailing
        # @yield Mail::Message
        def before_send(&block)
          before_send_blocks << block
        end

        # :nodoc:
        def before_send_blocks
          @before_send_blocks ||= []
        end

        # Callback after a Mailing has been sent.
        #
        #   after_send do |campaign_subscription, mailing, message|
        #     Slack.notify(:caffeinated, "A new subscriber to #{campaign_subscription.campaign.name}!")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        # @yield Caffeinate::Mailing
        # @yield Mail::Message
        def after_send(&block)
          after_send_blocks << block
        end

        # :nodoc:
        def after_send_blocks
          @after_send_blocks ||= []
        end

        # Callback after a CampaignSubscriber has exhausted all their mailings.
        #
        #   on_complete do |campaign_sub|
        #     Slack.notify(:caffeinated, "A subscriber completed #{campaign_sub.campaign.name}!")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        def on_complete(&block)
          on_complete_blocks << block
        end

        # :nodoc:
        def on_complete_blocks
          @on_complete_blocks ||= []
        end

        # Callback after a CampaignSubscriber has unsubscribed.
        #
        #   on_unsubscribe do |campaign_sub|
        #     Slack.notify(:caffeinated, "#{campaign_sub.id} has unsubscribed... sad day.")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        def on_unsubscribe(&block)
          on_unsubscribe_blocks << block
        end

        # :nodoc:
        def on_unsubscribe_blocks
          @on_unsubscribe_blocks ||= []
        end

        # Callback after a `Caffeinate::Mailing` is skipped.
        #
        #   on_skip do |campaign_subscription, mailing, message|
        #     Slack.notify(:caffeinated, "#{campaign_sub.id} has unsubscribed... sad day.")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        # @yield Caffeinate::Mailing
        def on_skip(&block)
          on_skip_blocks << block
        end

        # :nodoc:
        def on_skip_blocks
          @on_skip_blocks ||= []
        end
      end
    end
  end
end
