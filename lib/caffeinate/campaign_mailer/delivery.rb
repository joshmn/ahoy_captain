# frozen_string_literal: true

module Caffeinate
  module CampaignMailer
    # Handles delivery of a Caffeinate::Mailer for a Caffeinate::CampaignMailer
    module Delivery
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # Delivers the given Caffeinate::Mailing
        #
        # @param [Caffeinate::Mailing] mailing The mailing to deliver
        def deliver!(mailing)
          Thread.current[:current_caffeinate_mailing] = mailing

          if mailing.drip.parameterized?
            mailing.mailer_class.constantize.with(subscriber: mailing.subscriber, user: mailing.user).send(mailing.mailer_action).deliver
          else
            mailing.mailer_class.constantize.send(mailing.mailer_action, mailing.subscriber).deliver
          end
        end
      end
    end
  end
end
