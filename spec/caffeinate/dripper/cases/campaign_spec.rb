# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Campaign do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'campaign_test_dripper') }
  class CampaignTestDripper < ::Caffeinate::Dripper::Base
self.campaign = :campaign_test_dripper
  end
  class NoCampaignTestDripper < ::Caffeinate::Dripper::Base; end

  context '.campaign' do
    it 'returns campaign' do
      expect(CampaignTestDripper.caffeinate_campaign).to eq(campaign)
    end
  end

  context '#campaign' do
    it 'returns the campaign' do
      expect(CampaignTestDripper.new.campaign).to eq(campaign)
    end
  end

  context 'without a campaign slug' do
    it 'raises ArgumentError' do
      expect do
        NoCampaignTestDripper.caffeinate_campaign
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
