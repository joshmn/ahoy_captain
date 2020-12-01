# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    # Convenience for setting `@mailing`, and convenience methods for inferred `caffeinate_unsubscribe_url` and
    # `caffeinate_subscribe_url`.
    module Extension
      def self.included(klass)
        klass.before_action do
          @mailing = params[:mailing] if params
        end

        klass.helper_method :caffeinate_unsubscribe_url, :caffeinate_subscribe_url
      end

      # Assumes `@mailing` is set
      def caffeinate_unsubscribe_url(mailing: nil, **options)
        mailing ||= @mailing
        Caffeinate::UrlHelpers.caffeinate_unsubscribe_url(mailing.caffeinate_campaign_subscription, **options)
      end

      # Assumes `@mailing` is set
      def caffeinate_subscribe_url(mailing: nil, **options)
        mailing ||= @mailing
        Caffeinate::UrlHelpers.caffeinate_subscribe_url(mailing.caffeinate_campaign_subscription, **options)
      end
    end
  end
end
