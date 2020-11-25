# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::CampaignMailer::Campaign do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'campaign_test_campaign_mailer') }
  class CampaignTestCampaignMailer < ::Caffeinate::CampaignMailer::Base
    campaign :campaign_test_campaign_mailer
  end
  class NoCampaignTestCampaignMailer < ::Caffeinate::CampaignMailer::Base; end

  context '.campaign' do
    it 'returns campaign' do
      expect(CampaignTestCampaignMailer.caffeinate_campaign).to eq(campaign)
    end
  end

  context '#campaign' do
    it 'returns the campaign' do
      expect(CampaignTestCampaignMailer.new.campaign).to eq(campaign)
    end
  end

  context 'without a campaign slug' do
    it 'raises ArgumentError' do
      expect do
        NoCampaignTestCampaignMailer.caffeinate_campaign
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
