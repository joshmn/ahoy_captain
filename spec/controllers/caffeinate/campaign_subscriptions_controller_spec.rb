# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::CampaignSubscriptionsController, type: :controller do
  render_views
  routes { Caffeinate::Engine.routes }
  let!(:campaign) { create(:caffeinate_campaign, slug: 'campaign_subscriptions_controller_test') }
  class CampaignControllerTestDripper < ::Caffeinate::Dripper::Base
    self.campaign = :campaign_subscriptions_controller_test
  end

  context 'a valid token' do
    it 'unsubscribes if not subscribed' do
      subscription = create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign)
      expect(subscription.subscribed?).to be_truthy
      get :unsubscribe, params: { token: subscription.token }
      expect(response.body).to include('unsubscribed')
      expect(response).to have_http_status(:ok)
      subscription.reload
      expect(subscription.subscribed?).to be_falsey
      expect(subscription.unsubscribed?).to be_truthy
    end

    it 'unsubscribes even if already unsubscribed' do
      subscription = create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign, unsubscribed_at: Time.current)
      expect(subscription.subscribed?).to be_falsey
      get :unsubscribe, params: { token: subscription.token }
      expect(response.body).to include('unsubscribed')
      expect(response).to have_http_status(:ok)
      subscription.reload
      expect(subscription.subscribed?).to be_falsey
      expect(subscription.unsubscribed?).to be_truthy
    end
  end

  context 'an invalid token' do
    it 'raises ActiveRecord::RecordNotFound' do
      expect do
        get :unsubscribe, params: { token: 'meow' }
      end.to raise_error(::ActiveRecord::RecordNotFound)
    end
  end
end
