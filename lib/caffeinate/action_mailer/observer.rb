module Caffeinate
  module ActionMailer
    # Handles updating the Caffeinate::Message if it's available in Thread.current[:current_caffeinate_mailing]
    # and runs any associated callbacks
    class Observer
      def self.delivered_email(message)
        mailing = Thread.current[:current_caffeinate_mailing]
        return unless mailing
        if message.perform_deliveries
          mailing.update!(sent_at: Time.current)
        end
        mailing.caffeinate_campaign.to_mailer.run_callbacks(:after_send, mailing, message)
      end
    end
  end
end
