# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Callbacks do
  class CallbacksTestOneDripper < ::Caffeinate::Dripper::Base
self.campaign = :callbacks_test_one

    on_subscribe do
      @ran = true
    end
  end

  class CallbacksTestTwoDripper < ::Caffeinate::Dripper::Base
self.campaign = :callbacks_test_two

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
      expect(CallbacksTestOneDripper.on_subscribe_blocks.size).to eq(1)
      expect(CallbacksTestOneDripper.instance_variable_get(:@ran)).to be_falsey
      campaign_one.subscribe(company)
      expect(CallbacksTestOneDripper.instance_variable_get(:@ran)).to be_truthy

      expect(CallbacksTestTwoDripper.on_subscribe_blocks.size).to eq(2)
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran)).to be_falsey
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran_two)).to be_falsey
      campaign_two.subscribe(company)
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran)).to be_truthy
      expect(CallbacksTestTwoDripper.instance_variable_get(:@ran_two)).to be_truthy
    end
  end
end
