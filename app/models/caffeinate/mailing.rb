# frozen_string_literal: true

# == Schema Information
#
# Table name: caffeinate_mailings
#
#  id                                  :integer          not null, primary key
#  caffeinate_campaign_subscription_id :integer          not null
#  send_at                             :datetime
#  sent_at                             :datetime
#  skipped_at                          :datetime
#  mailer_class                        :string           not null
#  mailer_action                       :string           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
module Caffeinate
  # Records of the mails sent and to be sent for a given `::Caffeinate::CampaignSubscriber`
  class Mailing < ApplicationRecord
    CURRENT_THREAD_KEY = :current_caffeinate_mailing

    self.table_name = 'caffeinate_mailings'

    belongs_to :caffeinate_campaign_subscription, class_name: 'Caffeinate::CampaignSubscription'
    has_one :caffeinate_campaign, through: :caffeinate_campaign_subscription

    scope :upcoming, -> { unsent.unskipped.where('send_at < ?', ::Caffeinate.config.time_now).order('send_at asc') }
    scope :unsent, -> { unskipped.where(sent_at: nil) }
    scope :sent, -> { unskipped.where.not(sent_at: nil) }
    scope :skipped, -> { where.not(skipped_at: nil) }
    scope :unskipped, -> { where(skipped_at: nil) }

    # Checks if the Mailing is not skipped and not sent
    def pending?
      unskipped? && unsent?
    end

    # Checks if the Mailing is skipped
    def skipped?
      skipped_at.present?
    end

    # Checks if the Mailing is not skipped
    def unskipped?
      !skipped?
    end

    # Checks if the Mailing is sent
    def sent?
      sent_at.present?
    end

    # Checks if the Mailing is not sent
    def unsent?
      !sent?
    end

    # Updates `skipped_at and runs `on_skip` callbacks
    def skip!
      update!(skipped_at: Caffeinate.config.time_now)

      caffeinate_campaign.to_dripper.run_callbacks(:on_skip, caffeinate_campaign_subscription, self)
    end

    # The associated drip
    # @todo This can be optimized with a better cache
    def drip
      @drip ||= caffeinate_campaign.to_dripper.drip_collection.for(mailer_action)
    end

    # The associated Subscriber from `::Caffeinate::CampaignSubscription`
    def subscriber
      caffeinate_campaign_subscription.subscriber
    end

    # The associated Subscriber from `::Caffeinate::CampaignSubscription`
    def user
      caffeinate_campaign_subscription.user
    end

    # Assigns attributes to the Mailing from the Drip
    def from_drip(drip)
      self.send_at = drip.send_at
      self.mailer_class = drip.options[:mailer_class]
      self.mailer_action = drip.action
      self
    end

    # Handles the logic for delivery and delivers
    def process!
      if ::Caffeinate.config.async_delivery?
        deliver_later!
      else
        deliver!
      end
    end

    # Delivers the Mailing in the foreground
    def deliver!
      caffeinate_campaign_subscription.deliver!(self)
    end

    # Delivers the Mailing in the background
    def deliver_later!
      klass = ::Caffeinate.config.mailing_job_class
      if klass.respond_to?(:perform_later)
        klass.perform_later(id)
      elsif klass.respond_to?(:perform_async)
        klass.perform_async(id)
      else
        raise NoMethodError, "Neither perform_later or perform_async are defined on #{klass}."
      end
    end
  end
end
