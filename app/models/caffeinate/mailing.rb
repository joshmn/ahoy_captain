# frozen_string_literal: true

module Caffeinate
  class Mailing < ApplicationRecord
    self.table_name = 'caffeinate_mailings'

    belongs_to :caffeinate_campaign_subscription, class_name: 'Caffeinate::CampaignSubscription'
    has_one :caffeinate_campaign, through: :caffeinate_campaign_subscription

    scope :upcoming, -> { unsent.unskipped.where('send_at < ?', ::Caffeinate.config.time_now).order('send_at asc') }
    scope :unsent, -> { unskipped.where(sent_at: nil) }
    scope :sent, -> { unskipped.where.not(sent_at: nil) }
    scope :skipped, -> { where.not(skipped_at: nil) }
    scope :unskipped, -> { where(skipped_at: nil) }

    def skip!
      update!(skipped_at: Caffeinate.config.time_now)
    end

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

    def process!
      if ::Caffeinate.config.async_delivery?
        deliver_later!
      else
        deliver!
      end
    end

    def deliver!
      caffeinate_campaign_subscription.deliver!(self)
    end

    def deliver_later!
      klass = ::Caffeinate.config.mailing_job_class
      if klass.respond_to?(:perform_later)
        klass.perform_later(self.id)
      elsif klass.respond_to?(:perform_async)
        klass.perform_async(self.id)
      else
        raise NoMethodError, "Neither perform_later or perform_async are defined on #{klass}."
      end
    end
  end
end
