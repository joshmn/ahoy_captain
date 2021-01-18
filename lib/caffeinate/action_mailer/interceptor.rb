# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    # Handles the evaluation of a drip against a mailing to determine if it ultimately gets delivered.
    # Also invokes the `before_send` callbacks.
    class Interceptor
      def self.delivering_email(message)
        mailing = message.caffeinate_mailing
        return unless mailing

        mailing.caffeinate_campaign.to_dripper.run_callbacks(:before_send, mailing, message)
        drip = mailing.drip
        message.perform_deliveries = drip.enabled?(mailing)
      end
    end
  end
end
