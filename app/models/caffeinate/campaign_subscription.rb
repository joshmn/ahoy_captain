# frozen_string_literal: true

module Caffeinate
  # CampaignSubscription associates an object and its optional user to a Campaign.
  class CampaignSubscription < ApplicationRecord
    self.table_name = 'caffeinate_campaign_subscriptions'

    has_many :caffeinate_mailings, class_name: 'Caffeinate::Mailing', foreign_key: :caffeinate_campaign_subscription_id
    belongs_to :next_mailing, -> { upcoming.unsent.limit(1).first }, class_name: '::Caffeinate::Mailing', foreign_key: :caffeinate_campaign_subscription_id
    belongs_to :caffeinate_campaign, class_name: 'Caffeinate::Campaign', foreign_key: :caffeinate_campaign_id
    belongs_to :subscriber, polymorphic: true
    belongs_to :user, polymorphic: true, optional: true

    # All CampaignSubscriptions that where `unsubscribed_at` is nil and `ended_at` is nil
    scope :active, -> { where(unsubscribed_at: nil, ended_at: nil) }

    # All CampaignSubscriptions that where `unsubscribed_at` is nil and `ended_at` is nil
    scope :subscribed, -> { active }

    scope :unsubscribed, -> { where.not(unsubscribed_at: nil) }

    # All CampaignSubscriptions that where `ended_at` is not nil
    scope :ended, -> { where.not(ended_at: nil) }

    before_validation :set_token!, on: [:create]
    validates :token, uniqueness: true, on: [:create]

    after_commit :create_mailings!, on: :create

    # Actually deliver and process the mail
    def deliver!(mailing)
      caffeinate_campaign.to_dripper.deliver!(mailing)
    end

    # Checks if the subscription is not ended and not unsubscribed
    def subscribed?
      !ended? && !unsubscribed?
    end

    # Checks if the CampaignSubscription is not subscribed
    def unsubscribed?
      !subscribed?
    end

    # Checks if the CampaignSubscription is ended
    def ended?
      ended_at.present?
    end

    # Updates `ended_at` and runs `on_complete` callbacks
    def end!
      update!(ended_at: ::Caffeinate.config.time_now)

      caffeinate_campaign.to_dripper.run_callbacks(:on_complete, self)
    end

    # Updates `unsubscribed_at` and runs `on_subscribe` callbacks
    def unsubscribe!
      update!(unsubscribed_at: ::Caffeinate.config.time_now)

      caffeinate_campaign.to_dripper.run_callbacks(:on_unsubscribe, self)
    end

    private

    # Create mailings according to the drips registered in the Campaign
    def create_mailings!
      caffeinate_campaign.to_dripper.drips.each do |drip|
        mailing = Caffeinate::Mailing.new(caffeinate_campaign_subscription: self).from_drip(drip)
        mailing.save!
      end
      caffeinate_campaign.to_dripper.run_callbacks(:on_subscribe, self)
    end

    def set_token!
      loop do
        self.token = SecureRandom.uuid
        break unless self.class.exists?(token: token)
      end
    end
  end
end
