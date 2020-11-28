# frozen_string_literal: true

module Caffeinate
  module ActiveRecord
    # Includes the ActiveRecord association and relevant scopes for an ActiveRecord-backed model
    module Extension
      # Adds the associations for a subscriber
      def caffeinate_subscriber
        has_many :caffeinate_campaign_subscriptions, as: :subscriber, class_name: '::Caffeinate::CampaignSubscription', dependent: :destroy
        has_many :caffeinate_campaigns, through: :caffeinate_campaign_subscriptions, class_name: '::Caffeinate::Campaign'
        has_many :caffeinate_mailings, through: :caffeinate_campaign_subscriptions, class_name: '::Caffeinate::Mailing'

        scope :not_subscribed_to_campaign, lambda { |list|
          subscribed = ::Caffeinate::CampaignSubscription.select(:subscriber_id).joins(:caffeinate_campaign).where(caffeinate_campaigns: { slug: list }, subscriber_type: name)
          where.not(id: subscribed)
        }

        scope :unsubscribed_from_campaign, lambda { |list|
          unsubscribed = ::Caffeinate::CampaignSubscription
                         .unsubscribed
                         .select(:subscriber_id)
                         .joins(:caffeinate_campaign)
                         .where(caffeinate_campaigns: { slug: list }, subscriber_type: name)
          where(id: unsubscribed)
        }
      end

      # Adds the associations for a user
      def caffeinate_user
        has_many :caffeinate_campaign_subscriptions_as_user, as: :user, class_name: '::Caffeinate::CampaignSubscription'
      end
    end
  end
end
