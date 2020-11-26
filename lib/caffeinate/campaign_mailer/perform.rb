# frozen_string_literal: true

module Caffeinate
  module CampaignMailer
    # Handles delivering a `Caffeinate::Mailing` for the `Caffeinate::CampaignMailer`
    module Perform
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      # Delivers the next_caffeinated_mailer for the campaign's subscribers.
      #
      #   OrderCampaignMailer.new.perform!
      #
      # @return nil
      def perform!
        campaign.caffeinate_campaign_subscriptions.joins(:next_caffeinate_mailing).includes(:next_caffeinate_mailing).each do |subscriber|
          subscriber.next_caffeinate_mailing.process!
        end
        true
      end

      module ClassMethods
        # Convenience method for CampaignMailer::Base#perform
        def perform!
          new.perform!
        end
      end
    end
  end
end
