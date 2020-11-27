# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    module Extension
      def self.included(klass)
        klass.before_action do
          @mailing = Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY] if Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY]
        end

        klass.helper_method :caffeinate_unsubscribe_url, :caffeinate_subscribe_url
      end

      def caffeinate_unsubscribe_url(**options)
        Caffeinate::UrlHelpers.caffeinate_unsubscribe_url(@mailing.caffeinate_campaign_subscription, **options)
      end

      def caffeinate_subscribe_url
        Caffeinate::UrlHelpers.caffeinate_subscribe_url(@mailing.caffeinate_campaign_subscription, **options)
      end
    end
  end
end
