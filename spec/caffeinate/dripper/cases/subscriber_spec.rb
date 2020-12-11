# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Subscriber do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'caffeinate_subscriber_dripper_test') }

  class SubscriberDripper < ::Caffeinate::Dripper::Base
    self.campaign = :caffeinate_subscriber_dripper_test

    subscribes do
      Company.all.includes(:user).each do |company|
        subscribe(company, user: company.user)
      end
    end
  end

  describe '.subscribe!' do
    let!(:company_1) { create(:company) }
    let!(:user) { create(:user) }
    let!(:company_2) { create(:company, user: user) }

    context 'without any subscribers' do
      it 'has zero campaign subscriptions' do
        expect(campaign.caffeinate_campaign_subscriptions.count).to eq(0)
      end
    end

    context 'two potential subscribers' do
      before do
        SubscriberDripper.subscribe!
      end

      it 'has two subscriptions' do
        expect(campaign.caffeinate_campaign_subscriptions.count).to eq(2)
      end

      it 'has one subscription with a user' do
        expect(campaign.caffeinate_campaign_subscriptions.where(user: user).count).to eq(1)
      end

      it 'has one subscriber as a company with user' do
        expect(campaign.caffeinate_campaign_subscriptions.where(subscriber: company_2, user: user).count).to eq(1)
      end

      it 'has no subscribers with a company and a user that are not associated' do
        expect(campaign.caffeinate_campaign_subscriptions.where(subscriber: company_1, user: user).count).to eq(0)
      end

      it 'has a subscriber with just a company' do
        expect(campaign.caffeinate_campaign_subscriptions.where(subscriber: company_1).count).to eq(1)
      end
    end
  end

  describe '.subscribe' do
    context 'with a single argument' do
      let(:company) { create(:company) }
      let(:subscription) { SubscriberDripper.subscribe(company) }

      it 'creates a subscriber' do
        expect(subscription).to be_persisted
      end

      it 'returns a Caffeinate::CampaignSubscription object' do
        expect(subscription).to be_a(Caffeinate::CampaignSubscription)
      end

      it 'assigns CampaignSubscription#subscriber to the given object' do
        expect(subscription.subscriber).to eq(company)
      end
    end

    context 'with kwargs' do
      let(:company) { create(:company) }
      let(:user) { create(:user) }
      let(:subscription) { SubscriberDripper.subscribe(company, user: user) }

      it 'creates a subscriber' do
        expect(subscription).to be_persisted
      end

      it 'returns a Caffeinate::CampaignSubscription object' do
        expect(subscription).to be_a(Caffeinate::CampaignSubscription)
      end

      it 'assigns CampaignSubscription#subscriber to the given object' do
        expect(subscription.subscriber).to eq(company)
      end

      it 'assigns CampaignSubscription#user to the user key' do
        expect(subscription.user).to eq(user)
      end
    end
  end

  describe '.subscriptions' do
    it 'is caffeinate_campaign_subscriptions' do
      expect(SubscriberDripper.subscriptions.to_sql).to eq(::Caffeinate::CampaignSubscription.where(caffeinate_campaign_id: SubscriberDripper.campaign.id).to_sql)
    end
  end

  describe '.unsubscribe' do
    let!(:company) { create(:company) }
    let!(:subscription) { SubscriberDripper.subscribe(company) }

    it 'unsubscribes' do
      SubscriberDripper.unsubscribe(company)
      expect(subscription.reload.unsubscribed_at).to be_present
    end
  end
end
