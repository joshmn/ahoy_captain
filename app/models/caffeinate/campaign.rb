# frozen_string_literal: true

# == Schema Information
#
# Table name: caffeinate_campaigns
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Caffeinate
  # Campaign ties together subscribers and mailings, and provides one core model for handling your Drippers.
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
