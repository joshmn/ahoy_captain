# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::Drip do
  describe '#parameterized?' do
    it 'is true if using: :parameterized' do
      drip = described_class.new(nil, nil, using: :parameterized)
      expect(drip).to be_parameterized
    end

    it 'is false if not using: :parameterized' do
      drip = described_class.new(nil, nil, using: :asdf)
      expect(drip).not_to be_parameterized
    end
  end

  describe '#send_at' do
    let(:drip) { described_class.new(nil, nil, delay: 3.hours)  }
    it 'is a time' do
      expect(drip.send_at).to be_a(::ActiveSupport::TimeWithZone)
    end
    it 'is from_now' do
      expect(drip.send_at.to_i).to eq(3.hours.from_now.to_i)
    end
  end

  describe '#enabled?' do
    it 'works' do
      drip = described_class.new(nil, nil, {})
      expect(drip).to respond_to(:enabled?)
    end

    context 'evaluation' do
      let!(:campaign) { create(:caffeinate_campaign, slug: 'delivery_test_dripper') }
      let(:campaign_subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
      let(:mailing) { create(:caffeinate_mailing, caffeinate_campaign_subscription: campaign_subscription, mailer_class: 'DeliveryTestMailer', mailer_action: 'welcome') }

      class DripTestDripper < ::Caffeinate::Dripper::Base
        self.campaign = :drip_test_campaign
        default mailer_class: "TestMailer"
        drip :nil_test, delay: 0 do
          nil
        end

        drip :false_test, delay: 0 do
          false
        end

        drip :true_test, delay: 0 do
          true
        end

        drip :unsubscribe_test, delay: 0 do
          unsubscribe!
        end

        drip :end_test, delay: 0 do
          end!
        end

        drip :skip_test, delay: 0 do
          skip!
        end
      end

      it 'is true if the block returns nil' do
        expect(DripTestDripper.drip_collection.for(:nil_test).enabled?(Caffeinate::Mailing.new)).to eq(true)
      end

      it 'is true if the block returns true' do
        expect(DripTestDripper.drip_collection.for(:true_test).enabled?(Caffeinate::Mailing.new)).to eq(true)
      end

      it 'is false if the block ends' do
        expect(DripTestDripper.drip_collection.for(:end_test).enabled?(mailing)).to eq(false)
      end

      it 'is false if the block skips' do
        expect(DripTestDripper.drip_collection.for(:skip_test).enabled?(mailing)).to eq(false)
      end
    end
  end
end
