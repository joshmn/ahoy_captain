# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    # Handles updating the Caffeinate::Message if it's available in Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY]
    # and runs any associated callbacks
    class Observer
      def self.delivered_email(message)
        mailing = Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY]
        return unless mailing

        mailing.update!(sent_at: Caffeinate.config.time_now, skipped_at: nil) if message.perform_deliveries
        mailing.caffeinate_campaign.to_dripper.run_callbacks(:after_send, mailing.caffeinate_campaign_subscription, mailing, message)
      end
    end
  end
end
