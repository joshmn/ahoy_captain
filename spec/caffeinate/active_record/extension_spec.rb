# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::ActiveRecord::Extension do
  before do
    Company.caffeinate_subscriber
    User.caffeinate_user
  end

  class CaffeinateActiveRecordCampaign < ::Caffeinate::Dripper::Base
self.campaign = :caffeinate_active_record_extension
  end

  context '#caffeinate_subscriber' do
    let!(:campaign) { create(:caffeinate_campaign, slug: :caffeinate_active_record_extension) }
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:company) { subscription.subscriber }

    it 'has_many caffeinate_campaign_subscriptions' do
      expect(company.caffeinate_campaign_subscriptions.count).to eq(1)
      expect(company.caffeinate_campaign_subscriptions.first).to be_a(::Caffeinate::CampaignSubscription)
    end

    it 'has_many caffeinate_campaigns' do
      expect(company.caffeinate_campaigns.count).to eq(1)
      expect(company.caffeinate_campaigns.first).to be_a(::Caffeinate::Campaign)
    end

    it 'has_many caffeinate_mailings' do
      expect(company.caffeinate_mailings.count).to eq(0)
    end
  end

  context '#caffeinate_user' do
    let!(:campaign) { create(:caffeinate_campaign, slug: :caffeinate_active_record_extension) }
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:user) { subscription.user }

    it 'has_many caffeinate_campaign_subscriptions' do
      expect(user.caffeinate_campaign_subscriptions_as_user.count).to eq(1)
      expect(user.caffeinate_campaign_subscriptions_as_user.first).to be_a(::Caffeinate::CampaignSubscription)
    end
  end
end
