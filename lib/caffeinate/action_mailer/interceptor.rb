# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    class Interceptor
      # Handles `before_send` callbacks for a `Caffeinate::Dripper`
      def self.delivering_email(message)
        mailing = Thread.current[:current_caffeinate_mailing]
        return unless mailing

        mailing.caffeinate_campaign.to_dripper.run_callbacks(:before_send, mailing.caffeinate_campaign_subscription, mailing, message)
        drip = mailing.drip
        message.perform_deliveries = drip.enabled?(mailing)
      end
    end
  end
end
