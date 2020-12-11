# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Campaign do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'campaign_test_dripper') }

  class CampaignTestDripper < ::Caffeinate::Dripper::Base
    self.campaign = :campaign_test_dripper
  end
  class NoCampaignTestDripper < ::Caffeinate::Dripper::Base; end

  describe '.campaign' do
    it 'returns campaign' do
      expect(CampaignTestDripper.campaign).to eq(campaign)
    end
  end

  describe '#campaign' do
    it 'returns the campaign' do
      expect(CampaignTestDripper.new.campaign).to eq(campaign)
    end
  end

  context 'without a campaign slug when Config.implicit_campaigns is false' do
    before do
      ::Caffeinate.config.implicit_campaigns = false
    end

    after do
      ::Caffeinate.config.implicit_campaigns = true
    end

    it 'raises ArgumentError' do
      expect do
        NoCampaignTestDripper.campaign
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'implicit campaign' do
    it 'creates a campaign' do
      class FunkyDripThingDripper < ::Caffeinate::Dripper::Base; end
      expect(::Caffeinate::Campaign.find_by(slug: 'funky_drip_thing_dripper')).to be_nil
      campaign = FunkyDripThingDripper.campaign
      expect(campaign).to be_persisted
      expect(campaign.slug).to eq('funky_drip_thing')
      expect(campaign.name).to eq('Funky Drip Thing Campaign')
    end
  end
end
