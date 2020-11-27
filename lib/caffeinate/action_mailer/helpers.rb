module Caffeinate
  module ActionMailer
    module Helpers
      def caffeinate_unsubscribe_url(caffeinate_campaign_subscription, **options)
        opts = (::ActionMailer::Base.default_url_options || {}).merge(options)
        Caffeinate::Engine.routes.url_helpers.caffeinate_unsubscribe_url(token: caffeinate_campaign_subscription.token, **opts)
      end
    end
  end
end
