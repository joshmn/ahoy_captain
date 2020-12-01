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

  context '.subscribe!' do
    let!(:company_1) { create(:company) }
    let!(:user) { create(:user) }
    let!(:company_2) { create(:company, user: user) }

    it 'sends a mail' do
      expect(campaign.caffeinate_campaign_subscriptions.count).to eq(0)
      SubscriberDripper.subscribe!
      expect(campaign.caffeinate_campaign_subscriptions.count).to eq(2)
      expect(campaign.caffeinate_campaign_subscriptions.where(user: user).count).to eq(1)
      expect(campaign.caffeinate_campaign_subscriptions.where(subscriber: company_2, user: user).count).to eq(1)
      expect(campaign.caffeinate_campaign_subscriptions.where(subscriber: company_1, user: user).count).to eq(0)
      expect(campaign.caffeinate_campaign_subscriptions.where(subscriber: company_1).count).to eq(1)
    end
  end
end
