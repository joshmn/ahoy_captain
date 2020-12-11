# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::CampaignSubscription do
  let(:campaign) { create(:caffeinate_campaign, :with_dripper) }
  let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }

  describe '#end!' do
    context 'without argument' do
      it 'is not ended' do
        expect(subscription).not_to be_ended
      end

      context 'after #end!' do
        before do
          subscription.end!
        end

        it 'is #ended?' do
          expect(subscription).to be_ended
        end

        it 'has #ended_at' do
          expect(subscription.ended_at).to be_between(1.second.ago, Time.current)
        end

        it 'does not update #ended_reason' do
          expect(subscription.ended_reason).to be_blank
        end
      end
    end

    context 'with argument' do
      before do
        subscription.end!("no more pasta")
      end

      it 'is #ended?' do
        expect(subscription).to be_ended
      end

      it 'has #ended_at' do
        expect(subscription.ended_at).to be_between(1.second.ago, Time.current)
      end

      it 'does not update #ended_reason' do
        expect(subscription.ended_reason).to eq("no more pasta")
      end
    end
  end

  describe '#unsubscribe!' do
    context 'without argument' do
      it 'is not unsubscribed' do
        expect(subscription).not_to be_unsubscribed
      end

      context 'after #unsubscribe!' do
        before do
          subscription.unsubscribe!
        end

        it 'is #ended?' do
          expect(subscription).to be_unsubscribed
        end

        it 'has #ended_at' do
          expect(subscription.unsubscribed_at).to be_between(1.second.ago, Time.current)
        end

        it 'does not update #unsubscribe_reason' do
          expect(subscription.unsubscribe_reason).to be_blank
        end
      end
    end

    context 'with argument' do
      before do
        subscription.unsubscribe!("no more pasta")
      end

      it 'is #unsubscribed?' do
        expect(subscription).to be_unsubscribed
      end

      it 'has #unsubscribed_at' do
        expect(subscription.unsubscribed_at).to be_between(1.second.ago, Time.current)
      end

      it 'does not update #unsubscribe_reason' do
        expect(subscription.unsubscribe_reason).to eq("no more pasta")
      end
    end
  end

  describe '#subscribed?' do
    it 'is true if ended_at is nil' do
      subscription.ended_at = nil
      expect(subscription).to be_subscribed
    end

    it 'false if ended_at is present' do
      subscription.ended_at = Time.current
      expect(subscription).not_to be_subscribed
    end

    it 'is false if unsubscribed_at is present' do
      subscription.unsubscribed_at = Time.current
      expect(subscription).not_to be_subscribed
    end

    it 'is false if ended_at and unsubscribed at are both somehow present' do
      subscription.ended_at = Time.current
      subscription.unsubscribed_at = Time.current
      expect(subscription).not_to be_subscribed
    end

    it 'is false if ended_at and unsubscribed at are both somehow present and resubscribed_at is present' do
      subscription.ended_at = Time.current
      subscription.unsubscribed_at = Time.current
      subscription.resubscribed_at = Time.current
      expect(subscription).not_to be_subscribed
    end
  end
end
