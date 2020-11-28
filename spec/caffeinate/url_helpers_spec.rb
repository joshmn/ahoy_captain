# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::UrlHelpers do

  let(:subscription) { ::Caffeinate::CampaignSubscription.new(token: "jesus") }
  before do
    ActionMailer::Base.default_url_options[:host] = 'caffeinate.test'
  end

  context '#caffeinate_unsubscribe_url' do
    it 'returns the url' do
      expect(described_class.caffeinate_unsubscribe_url(subscription)).to eq("http://caffeinate.test/caffeinate/campaign_subscriptions/jesus/unsubscribe")
    end
  end

  context '#caffeinate_subscribe_url' do
    it 'returns the url' do
      expect(described_class.caffeinate_subscribe_url(subscription)).to eq("http://caffeinate.test/caffeinate/campaign_subscriptions/jesus/subscribe")
    end
  end

  context '#caffeinate_unsubscribe_path' do
    it 'returns the url' do
      expect(described_class.caffeinate_unsubscribe_path(subscription)).to eq("/caffeinate/campaign_subscriptions/jesus/unsubscribe")
    end
  end

  context '#caffeinate_subscribe_path' do
    it 'returns the url' do
      expect(described_class.caffeinate_subscribe_path(subscription)).to eq("/caffeinate/campaign_subscriptions/jesus/subscribe")
    end
  end
end
