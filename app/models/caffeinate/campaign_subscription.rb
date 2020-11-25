module Caffeinate
  class CampaignSubscription < ApplicationRecord
    self.table_name = 'caffeinate_campaign_subscriptions'

    has_many :caffeinate_mailings, class_name: 'Caffeinate::Mailing', foreign_key: :caffeinate_campaign_subscription_id
    has_one :next_caffeinate_mailing, -> { upcoming.unsent.limit(1).first }, class_name: 'Caffeinate::Mailing', foreign_key: :caffeinate_campaign_subscription_id
    belongs_to :caffeinate_campaign, class_name: 'Caffeinate::Campaign', foreign_key: :caffeinate_campaign_id
    belongs_to :subscriber, polymorphic: true
    belongs_to :user, polymorphic: true, optional: true

    before_validation :set_token!, on: [:create]
    validates :token, uniqueness: true, on: [:create]

    after_commit :create_mailings!, on: :create

    def deliver!(mailing)
      caffeinate_campaign.to_mailer.deliver!(mailing)
    end

    def subscribed?
      ended_at.nil? && unsubscribed_at.nil?
    end

    def unsubscribed?
      !subscribed?
    end

    def end!
      update!(ended_at: Time.current)

      caffeinate_campaign.to_mailer.run_callbacks(:on_complete, self)
    end

    def unsubscribe!
      update!(unsubscribed_at: Time.current)

      caffeinate_campaign.to_mailer.run_callbacks(:on_unsubscribe, self)
    end

    private

    def create_mailings!
      caffeinate_campaign.to_mailer.drips.each do |drip|
        mailing = Caffeinate::Mailing.new(caffeinate_campaign_subscription: self).from_drip(drip)
        mailing.save!
      end
      caffeinate_campaign.to_mailer.run_callbacks(:on_subscribe, self)
    end

    def set_token!
      loop do
        self.token = SecureRandom.uuid
        break unless self.class.exists?(token: self.token)
      end
    end

  end
end
