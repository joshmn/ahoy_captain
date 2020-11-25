# frozen_string_literal: true

module Caffeinate
  class Mailing < ApplicationRecord
    self.table_name = 'caffeinate_mailings'

    belongs_to :caffeinate_campaign_subscription, class_name: 'Caffeinate::CampaignSubscription'
    has_one :caffeinate_campaign, through: :caffeinate_campaign_subscription

    scope :upcoming, -> { where('send_at < ?', Time.current).order('send_at asc') }
    scope :unsent, -> { where(sent_at: nil) }

    def drip
      @drip ||= caffeinate_campaign.to_mailer.drips.find { |drip| drip.action.to_s == mailer_action }
    end

    def subscriber
      caffeinate_campaign_subscription.subscriber
    end

    def user
      caffeinate_campaign_subscription.user
    end

    def from_drip(drip)
      self.send_at = drip.options[:delay].from_now
      self.mailer_class = drip.options[:mailer_class]
      self.mailer_action = drip.action
      self
    end

    def deliver!
      caffeinate_campaign_subscription.deliver!(self)
    end

    def deliver_later!
      caffeinate_campaign_subscription.deliver!(self)
    end
  end
end
