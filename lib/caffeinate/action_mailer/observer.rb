# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    # Handles updating the Caffeinate::Message if it's available in Mail::Message.caffeinate_mailing
    # and runs any associated callbacks
    class Observer
      def self.delivered_email(message)
        mailing = message.caffeinate_mailing
        return unless mailing

        mailing.update!(sent_at: Caffeinate.config.time_now, skipped_at: nil) if message.perform_deliveries
        mailing.caffeinate_campaign.to_dripper.run_callbacks(:after_send, mailing, message)
        true
      end
    end
  end
end
