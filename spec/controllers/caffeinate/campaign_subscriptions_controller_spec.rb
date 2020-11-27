require 'rails_helper'

describe Caffeinate::CampaignSubscriptionsController, type: :controller do
  routes { Caffeinate::Engine.routes }
  let!(:campaign) { create(:caffeinate_campaign, slug: 'campaign_subscriptions_controller_test') }
  class CampaignControllerTestDripper < ::Caffeinate::Dripper::Base
    campaign :campaign_subscriptions_controller_test
  end

  it 'works' do
    subscription = create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign)
    expect {
      get :unsubscribe, params: { token: subscription.token }
      subscription.reload
    }.to change(subscription, :unsubscribed_at)
  end
end
