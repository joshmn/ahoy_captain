# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::CampaignMailer::Callbacks do
  class CallbacksTestOneCampaignMailer < ::Caffeinate::CampaignMailer::Base
    campaign :callbacks_test_one

    on_subscribe do
      @ran = true
    end
  end

  class CallbacksTestTwoCampaignMailer < ::Caffeinate::CampaignMailer::Base
    campaign :callbacks_test_two

    on_subscribe do
      @ran = true
    end

    on_subscribe do
      @ran_two = true
    end
  end

  let!(:campaign_one) { create(:caffeinate_campaign, slug: :callbacks_test_one) }
  let!(:campaign_two) { create(:caffeinate_campaign, slug: :callbacks_test_two) }

  context '.on_subscribe' do
    it 'works' do
      company = create(:company)
      expect(CallbacksTestOneCampaignMailer.on_subscribe_blocks.size).to eq(1)
      expect(CallbacksTestOneCampaignMailer.instance_variable_get(:@ran)).to be_falsey
      campaign_one.subscribe(company)
      expect(CallbacksTestOneCampaignMailer.instance_variable_get(:@ran)).to be_truthy

      expect(CallbacksTestTwoCampaignMailer.on_subscribe_blocks.size).to eq(2)
      expect(CallbacksTestTwoCampaignMailer.instance_variable_get(:@ran)).to be_falsey
      expect(CallbacksTestTwoCampaignMailer.instance_variable_get(:@ran_two)).to be_falsey
      campaign_two.subscribe(company)
      expect(CallbacksTestTwoCampaignMailer.instance_variable_get(:@ran)).to be_truthy
      expect(CallbacksTestTwoCampaignMailer.instance_variable_get(:@ran_two)).to be_truthy
    end
  end
end
