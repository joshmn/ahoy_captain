# frozen_string_literal: true

module Caffeinate
  # Campaign.
  class Campaign < ApplicationRecord
    self.table_name = 'caffeinate_campaigns'
    has_many :caffeinate_campaign_subscriptions, class_name: 'Caffeinate::CampaignSubscription', foreign_key: :caffeinate_campaign_id
    has_many :caffeinate_mailings, through: :caffeinate_campaign_subscriptions, class_name: 'Caffeinate::CampaignSubscriptions'

    # Poorly-named Campaign class resolver
    def to_dripper
      Caffeinate.dripper_to_campaign_class[slug.to_sym].constantize
    end

    # Subscribes an object to a campaign.
    def subscribe(subscriber, **args)
      caffeinate_campaign_subscriptions.find_or_create_by(subscriber: subscriber, **args)
    end
  end
end
