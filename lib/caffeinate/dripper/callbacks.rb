# frozen_string_literal: true

module Caffeinate
  module Dripper
    # Callbacks for a Dripper.
    module Callbacks
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      def run_callbacks(name, *args)
        self.class.run_callbacks(name, *args)
      end

      def callbacks_for(name)
        self.class.callbacks_for(name)
      end

      module ClassMethods
        # :nodoc:
        def run_callbacks(name, *args)
          catch(:abort) do
            callbacks_for(name).each do |callback|
              callback.call(*args)
            end
            return true
          end
          false
        end

        # :nodoc:
        def callbacks_for(name)
          send("#{name}_blocks")
        end

        def before_subscribe(&block)
          before_subscribe_blocks << block
        end

        def before_subscribe_blocks
          @before_subscribe_blocks ||= []
        end

        # Callback after a Caffeinate::CampaignSubscription is created, and after the Caffeinate::Mailings have
        # been created.
        #
        #   on_subscribe do |campaign_subscription|
        #     Slack.notify(:caffeinate, "A new subscriber to #{campaign_subscription.campaign.name}!")
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

        # Callback after a Caffeinate::CampaignSubscription is `#resubscribed!`
        #
        #   on_resubscribe do |campaign_subscription|
        #     Slack.notify(:caffeinate, "Someone resubscribed to #{campaign_subscription.campaign.name}!")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        def on_resubscribe(&block)
          on_resubscribe_blocks << block
        end

        # :nodoc:
        def on_resubscribe_blocks
          @on_resubscribe_blocks ||= []
        end

        # Callback before the mailings get processed.
        #
        #   before_perform do |dripper|
        #     Slack.notify(:caffeinate, "Dripper is getting ready for mailing! #{dripper.caffeinate_campaign.name}!")
        #   end
        #
        # @yield Caffeinate::Dripper
        def before_perform(&block)
          before_perform_blocks << block
        end

        # :nodoc:
        def before_perform_blocks
          @before_perform_blocks ||= []
        end

        # Callback before the mailings get processed in a batch.
        #
        #   after_process do |dripper, mailings|
        #     Slack.notify(:caffeinate, "Dripper #{dripper.name} sent #{mailings.size} mailings! Whoa!")
        #   end
        #
        # @yield Caffeinate::Dripper
        # @yield Caffeinate::Mailing [Array]
        def on_perform(&block)
          on_perform_blocks << block
        end

        # :nodoc:
        def on_perform_blocks
          @on_perform_blocks ||= []
        end

        # Callback after the all the mailings have been sent.
        #
        #   after_process do |dripper|
        #     Slack.notify(:caffeinate, "Dripper #{dripper.name} sent #{mailings.size} mailings! Whoa!")
        #   end
        #
        # @yield Caffeinate::Dripper
        # @yield Caffeinate::Mailing [Array]
        def after_perform(&block)
          after_perform_blocks << block
        end

        # :nodoc:
        def after_perform_blocks
          @after_perform_blocks ||= []
        end

        # Callback before a Drip has called the mailer.
        #
        #   before_drip do |drip, mailing|
        #     Slack.notify(:caffeinate, "#{drip.action_name} is starting")
        #   end
        #
        # Note: If you want to bail on the mailing for some reason, you need invoke `throw(:abort)`
        #
        #   before_drip do |drip, mailing|
        #     if mailing.caffeinate_campaign_subscription.subscriber.trial_ended?
        #       unsubscribe!("Trial ended")
        #       throw(:abort)
        #     end
        #   end
        #
        # @yield Caffeinate::Drip current drip
        # @yield Caffeinate::Mailing
        def before_drip(&block)
          before_drip_blocks << block
        end

        # :nodoc:
        def before_drip_blocks
          @before_drip_blocks ||= []
        end

        # Callback before a Mailing has been sent.
        #
        #   before_send do |campaign_subscription, mailing, message|
        #     Slack.notify(:caffeinate, "A new subscriber to #{campaign_subscription.campaign.name}!")
        #   end
        #
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
        #     Slack.notify(:caffeinate, "A new subscriber to #{campaign_subscription.campaign.name}!")
        #   end
        #
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
        #     Slack.notify(:caffeinate, "A subscriber completed #{campaign_sub.campaign.name}!")
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
        #     Slack.notify(:caffeinate, "#{campaign_sub.id} has unsubscribed... sad day.")
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

        # Callback after a CampaignSubscriber has ended.
        #
        #   on_end do |campaign_sub|
        #     Slack.notify(:caffeinate, "#{campaign_sub.id} has ended... sad day.")
        #   end
        #
        # @yield Caffeinate::CampaignSubscription
        def on_end(&block)
          on_end_blocks << block
        end

        # :nodoc:
        def on_end_blocks
          @on_end_blocks ||= []
        end

        # Callback after a `Caffeinate::Mailing` is skipped.
        #
        #   on_skip do |campaign_subscription, mailing, message|
        #     Slack.notify(:caffeinate, "#{campaign_sub.id} has unsubscribed... sad day.")
        #   end
        #
        # @yield `Caffeinate::Mailing`
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
