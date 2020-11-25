# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    # Handles updating the Caffeinate::Message if it's available in Thread.current[:current_caffeinate_mailing]
    # and runs any associated callbacks
    class Observer
      def self.delivered_email(message)
        mailing = Thread.current[:current_caffeinate_mailing]
        return unless mailing

        mailing.update!(sent_at: Time.current) if message.perform_deliveries
        mailing.caffeinate_campaign.to_mailer.run_callbacks(:after_send, mailing, message)
      end
    end
  end
end
