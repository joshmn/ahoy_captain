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
    has_many :subscriptions, class_name: 'Caffeinate::CampaignSubscription', foreign_key: :caffeinate_campaign_id
    has_many :caffeinate_mailings, through: :caffeinate_campaign_subscriptions, class_name: 'Caffeinate::CampaignSubscriptions'
    has_many :mailings, through: :caffeinate_campaign_subscriptions, class_name: 'Caffeinate::CampaignSubscriptions'

    # Poorly-named Campaign class resolver
    def to_dripper
      ::Caffeinate.dripper_collection.resolve(self)
    end

    # Convenience method for find_by!(slug: value)
    #
    #   ::Caffeinate::Campaign[:onboarding]
    #   # is the same as
    #   ::Caffeinate::Campaign.find_by(slug: :onboarding)
    def self.[](val)
      find_by!(slug: val)
    end

    # Checks to see if the subscriber exists.
    def subscriber(record, **args)
      caffeinate_campaign_subscriptions.find_by(subscriber: record, **args)
    end

    # Check if the subscriber exists
    def subscribes?(record, **args)
      subscriber(record, **args).present?
    end

    # Unsubscribes an object from a campaign.
    #
    #   Campaign[:onboarding].unsubscribe(Company.first, user: Company.first.admin, reason: "Because I said so")
    #
    # is the same as
    #
    #  Campaign.find_by(slug: "onboarding").caffeinate_campaign_subscriptions.find_by(subscriber: Company.first, user: Company.first.admin).unsubscribe!("Because I said so")
    #
    # Just... mintier.
    def unsubscribe(subscriber, **args)
      reason = args.delete(:reason)
      subscription = subscriber(subscriber, **args)
      raise ::ActiveRecord::RecordInvalid, subscription if subscription.nil?

      subscription.unsubscribe!(reason)
    end

    # Creates a `CampaignSubscription` object for the present Campaign. Allows passing `**args` to
    # delegate additional arguments to the record. Uses `find_or_create_by`.
    def subscribe(subscriber, **args)
      caffeinate_campaign_subscriptions.find_or_create_by(subscriber: subscriber, **args)
    end

    # Subscribes an object to a campaign. Raises `ActiveRecord::RecordInvalid` if the record was invalid.
    def subscribe!(subscriber, **args)
      subscribe(subscriber, **args)
    end
  end
end
