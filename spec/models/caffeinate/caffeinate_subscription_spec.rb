# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::CampaignSubscription do
  let(:campaign) { create(:caffeinate_campaign, :with_dripper) }
  let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }

  context '#end!' do
    context 'without argument' do
      it 'updates #ended_at' do
        expect(subscription.ended?).to be_falsey
        subscription.end!
        expect(subscription.ended?).to be_truthy
        expect(subscription.ended_at).to be_between(1.second.ago, Time.current)
      end
      it 'does not update #ended_reason' do
        expect(subscription.ended?).to be_falsey
        subscription.end!
        expect(subscription.ended_reason).to be_blank
      end
    end

    context 'with argument' do
      it 'updates #ended_at' do
        expect(subscription.ended?).to be_falsey
        subscription.end!('Hello')
        expect(subscription.ended?).to be_truthy
        expect(subscription.ended_at).to be_between(1.second.ago, Time.current)
      end

      it 'updates #ended_reason' do
        expect(subscription.ended?).to be_falsey
        subscription.end!('Hello')
        expect(subscription.ended_reason).to eq('Hello')
      end
    end
  end

  context '#unsubscribe!' do
    context 'without argument' do
      it 'updates #unsubscribed_at' do
        expect(subscription.unsubscribed?).to be_falsey
        subscription.unsubscribe!
        expect(subscription.unsubscribed?).to be_truthy
        expect(subscription.unsubscribed_at).to be_between(1.second.ago, Time.current)
      end
      it 'does not update #unsubscribe_reason' do
        expect(subscription.unsubscribed?).to be_falsey
        subscription.unsubscribe!
        expect(subscription.unsubscribe_reason).to be_blank
      end
    end

    context 'with argument' do
      it 'updates unsubscribe_reason' do
        expect(subscription.unsubscribed?).to be_falsey
        subscription.unsubscribe!('Hello')
        expect(subscription.unsubscribed?).to be_truthy
      end

      it 'updates unsubscribe_reason' do
        expect(subscription.unsubscribed?).to be_falsey
        subscription.unsubscribe!('Hello')
        expect(subscription.unsubscribe_reason).to eq('Hello')
      end
    end
  end

  context '#subscribed?' do
    it 'is false if ended_at is present' do
      expect(subscription.subscribed?).to be_truthy
      subscription.ended_at = Time.current
      expect(subscription.subscribed?).to be_falsey
    end

    it 'is false if unsubscribed_at is present' do
      expect(subscription.subscribed?).to be_truthy
      subscription.unsubscribed_at = Time.current
      expect(subscription.subscribed?).to be_falsey
    end

    it 'is false if ended_at and unsubscribed at are both somehow present' do
      expect(subscription.subscribed?).to be_truthy
      subscription.ended_at = Time.current
      subscription.unsubscribed_at = Time.current
      expect(subscription.subscribed?).to be_falsey
    end

    it 'is false if ended_at and unsubscribed at are both somehow present and resubscribed_at is present' do
      expect(subscription.subscribed?).to be_truthy
      subscription.ended_at = Time.current
      subscription.unsubscribed_at = Time.current
      subscription.resubscribed_at = Time.current
      expect(subscription.subscribed?).to be_falsey
    end
  end
end
