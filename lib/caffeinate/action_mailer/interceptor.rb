module Caffeinate
  module ActionMailer
    class Interceptor
      # Handles `before_send` callbacks for a `Caffeinate::CampaignMailer`
      def self.delivering_email(message)
        mailing = Thread.current[:current_caffeinate_mailing]
        return unless mailing

        mailing.caffeinate_campaign.to_mailer.run_callbacks(:before_send, mailing, message)
        drip = mailing.drip
        message.perform_deliveries = drip.enabled?(mailing)
      end
    end
  end
end
