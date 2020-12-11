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

  describe '#caffeinate_subscriber' do
    let!(:campaign) { create(:caffeinate_campaign, slug: :caffeinate_active_record_extension) }
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:company) { subscription.subscriber }

    it 'has a count on campaign sub' do
      expect(company.caffeinate_campaign_subscriptions.count).to eq(1)
    end

    it 'has_many Caffeinate::CampaignSubscription' do
      expect(company.caffeinate_campaign_subscriptions.first).to be_a(::Caffeinate::CampaignSubscription)
    end

    it 'has a count' do
      expect(company.caffeinate_campaigns.count).to eq(1)
    end

    it 'has_many Caffeinate::Campaign' do
      expect(company.caffeinate_campaigns.first).to be_a(::Caffeinate::Campaign)
    end

    it 'has_many caffeinate_mailings' do
      expect(company.caffeinate_mailings.count).to eq(0)
    end
  end

  describe '#caffeinate_user' do
    let!(:campaign) { create(:caffeinate_campaign, slug: :caffeinate_active_record_extension) }
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:user) { subscription.user }

    it 'counts' do
      expect(user.caffeinate_campaign_subscriptions_as_user.count).to eq(1)
    end

    it 'has_many Caffeinate::CampaignSubscriptions' do
      expect(user.caffeinate_campaign_subscriptions_as_user.first).to be_a(::Caffeinate::CampaignSubscription)
    end
  end

  context 'scopes' do
    describe '.not_subscribed_to_campaign' do
      it 'is not table' do
        expect(Company.not_subscribed_to_campaign('campaign').to_sql).to include(Caffeinate::CampaignSubscription.table_name)
      end
    end

    describe '.unsubscribed_from_campaign' do
      it 'is table' do
        expect(Company.unsubscribed_from_campaign('campaign').to_sql).to include(Caffeinate::CampaignSubscription.table_name)
      end
    end
  end
end
