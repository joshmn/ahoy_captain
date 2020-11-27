# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer do
  class HelpersTestMailer < ::ActionMailer::Base
    def test(subscription)
      mail do |format|
        format.text { render plain: Caffeinate::Engine.routes.url_helpers.unsubscribe_campaign_subscription_url(subscription.token, Rails.application.routes.default_url_options).to_s }
      end
    end
  end

  context 'it works' do
    it 'works' do
      subscription = build_stubbed(:caffeinate_campaign_subscription)
      subscription.token = 'jesus'
      expect(HelpersTestMailer.test(subscription).body.to_s).to eq('http://localhost:3000/caffeinate/campaign_subscriptions/jesus/unsubscribe')
    end
  end
end
