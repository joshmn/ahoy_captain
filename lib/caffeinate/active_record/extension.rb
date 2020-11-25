module Caffeinate
  module ActiveRecord
    module Extension
      def caffeinate_subscriber
        has_many :caffeinate_campaign_subscriptions, as: :subscriber, class_name: '::Caffeinate::CampaignSubscription'
        has_many :caffeinate_campaigns, through: :caffeinate_campaign_subscriptions, class_name: '::Caffeinate::Campaign'
        has_many :caffeinate_mailings, through: :caffeinate_campaign_subscriptions, class_name: '::Caffeinate::Mailing'
      end

      def caffeinate_user
        has_many :caffeinate_campaign_subscriptions_as_user, as: :user, class_name: '::Caffeinate::CampaignSubscription'
      end
    end
  end
end
