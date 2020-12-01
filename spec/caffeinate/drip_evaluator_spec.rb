# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::DripEvaluator do
  class DripEvaluatorMailer < ActionMailer::Base
    def hello_end; end

    def hello_skip; end

    def hello_unsubscribe; end
  end

  class DripEvaluatorDripper < ::Caffeinate::Dripper::Base
    self.campaign = :drip_evaluator
    default mailer_class: 'DripEvaluatorMailer', using: :parameterized
    drip :hello_end, delay: 0.hours do
      end!
    end
    drip :hello_skip, delay: 0.hours do
      skip!
    end
    drip :hello_unsubscribe, delay: 0.hours do
      unsubscribe!
    end
  end

  let!(:campaign) { create(:caffeinate_campaign, slug: 'drip_evaluator') }

  context '#end!' do
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:mailing) { subscription.caffeinate_mailings.find_by(mailer_action: 'hello_end') }

    it 'calls #end! on the campaign_subscription' do
      described_class.new(mailing).call(&mailing.drip.block)
      mailing.reload
      expect(mailing.caffeinate_campaign_subscription.ended?).to be_truthy
    end

    it 'returns false' do
      result = described_class.new(mailing).call(&mailing.drip.block)
      expect(result).to be_falsey
    end
  end

  context '#unsubscribe!' do
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:mailing) { subscription.caffeinate_mailings.find_by(mailer_action: 'hello_unsubscribe') }
    it 'calls #unsubscribe! on the campaign_subscription' do
      described_class.new(mailing).call(&mailing.drip.block)
      mailing.reload
      expect(mailing.caffeinate_campaign_subscription.unsubscribed?).to be_truthy
    end

    it 'returns false' do
      result = described_class.new(mailing).call(&mailing.drip.block)
      expect(result).to be_falsey
    end
  end

  context '#skip!' do
    let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    let(:mailing) { subscription.caffeinate_mailings.find_by(mailer_action: 'hello_skip') }
    it 'calls #skip! on the mailing' do
      described_class.new(mailing).call(&mailing.drip.block)
      mailing.reload
      expect(mailing.skipped?).to be_truthy
    end

    it 'returns false' do
      result = described_class.new(mailing).call(&mailing.drip.block)
      expect(result).to be_falsey
    end
  end
end
