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

    # Convenience method for find_by!(slug: value)
    #
    #   ::Caffeinate::Campaign[:onboarding]
    #   # is the same as
    #   ::Caffeinate::Campaign.find_by(slug: :onboarding)
    def self.[](val)
      find_by!(slug: val)
    end

    # Checks to see if the subscriber exists.
    #
    # Use `find_by` so that we don't have to load the record twice. Often used with `subscribes?`
    def subscriber(record, **args)
      @subscriber ||= caffeinate_campaign_subscriptions.find_by(subscriber: record, **args)
    end

    # Check if the subscriber exists
    def subscribes?(record, **args)
      subscriber(record, **args).exists?
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
      raise ActiveRecord::RecordInvalid, subscription if subscription.nil?

      subscription.unsubscribe!(reason)
    end

    # Subscribes an object to a campaign.
    def subscribe(subscriber, **args)
      caffeinate_campaign_subscriptions.find_or_create_by(subscriber: subscriber, **args)
    end

    # Subscribes an object to a campaign.
    def subscribe!(subscriber, **args)
      subscription = subscribe(subscriber, **args)
      return subscription if subscribe.persisted?

      raise ActiveRecord::RecordInvalid, subscription
    end
  end
end
