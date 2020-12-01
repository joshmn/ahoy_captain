# frozen_string_literal: true

# == Schema Information
#
# Table name: caffeinate_mailings
#
#  id                                  :integer          not null, primary key
#  caffeinate_campaign_subscription_id :integer          not null
#  send_at                             :datetime
#  sent_at                             :datetime
#  skipped_at                          :datetime
#  mailer_class                        :string           not null
#  mailer_action                       :string           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
require 'rails_helper'

describe ::Caffeinate::Mailing do
  let!(:campaign) { create(:caffeinate_campaign, slug: :caffeinate_active_record_extension) }
  let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
  let!(:unsent_mailings) { create_list(:caffeinate_mailing, 5, :unsent, caffeinate_campaign_subscription: subscription) }
  let!(:sent_mailings) { create_list(:caffeinate_mailing, 3, :sent, caffeinate_campaign_subscription: subscription) }
  let!(:skipped_mailings) { create_list(:caffeinate_mailing, 2, :skipped, caffeinate_campaign_subscription: subscription) }

  class CaffeinateMailingTestCampaign < ::Caffeinate::Dripper::Base
    self.campaign = :caffeinate_active_record_extension
  end

  context '#unsent' do
    it 'has 5 unsent mailings' do
      expect(described_class.unsent.count).to eq(5)
      expect(described_class.unsent).to eq(unsent_mailings)
    end
  end

  context '#sent' do
    it 'has 3 sent mailings' do
      expect(described_class.sent.count).to eq(3)
      expect(described_class.sent).to eq(sent_mailings)
    end
  end

  context '#skipped' do
    it 'has 3 skipped mailings' do
      expect(described_class.skipped.count).to eq(2)
      expect(described_class.skipped).to eq(skipped_mailings)
      expect(described_class.unskipped.count).to eq(8)
    end
  end

  context '#process' do
    context 'async' do
      it 'enqueues a job' do
        class MyJob < ActiveJob::Base
          include ::Caffeinate::DeliverAsync
        end
        Caffeinate.config.mailing_job = 'MyJob'
        Caffeinate.config.async_delivery = true
        mailing = sent_mailings.first.dup
        mailing.mailer_action = 'test'
        mailing.mailer_class = 'SuperTestMailer'
        mailing.caffeinate_campaign_subscription = create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign)
        expect do
          mailing.process!
        end.to change {
          ActiveJob::Base.queue_adapter.enqueued_jobs.count
        }.by 1
        Caffeinate.config.mailing_job = nil
        Caffeinate.config.async_delivery = false
      end
    end
  end

  context '#pending?' do
    it 'is not sent or skipped' do
      mailing = described_class.new
      expect(mailing.pending?).to be_truthy
      mailing.sent_at = Time.current
      expect(mailing.pending?).to be_falsey
      mailing.sent_at = 50.years.ago
      expect(mailing.pending?).to be_falsey
      mailing.sent_at = 50.years.from_now
      expect(mailing.pending?).to be_falsey
      mailing.sent_at = nil
      expect(mailing.pending?).to be_truthy
      mailing.skipped_at = Time.current
      expect(mailing.pending?).to be_falsey
      mailing.skipped_at = 50.years.ago
      expect(mailing.pending?).to be_falsey
      mailing.skipped_at = 50.years.from_now
      expect(mailing.pending?).to be_falsey
      mailing.skipped_at = Time.current
      mailing.sent_at = Time.current
      expect(mailing.pending?).to be_falsey
      mailing.skipped_at = 50.years.ago
      mailing.sent_at = 50.years.ago
      expect(mailing.pending?).to be_falsey
      mailing.skipped_at = 50.years.from_now
      mailing.sent_at = 50.years.from_now
      expect(mailing.pending?).to be_falsey
    end
  end

  context 'skipped' do
    context '#skipped?' do
      it 'has a present skipped_at' do
        mailing = described_class.new
        expect(mailing.skipped?).to be_falsey
        mailing.skipped_at = Time.current
        expect(mailing.skipped?).to be_truthy
        mailing.skipped_at = 50.years.ago
        expect(mailing.skipped?).to be_truthy
        mailing.skipped_at = 50.years.from_now
        expect(mailing.skipped?).to be_truthy
        mailing.skipped_at = nil
        expect(mailing.skipped?).to be_falsey
      end
    end

    describe '#process!' do
      class SkippedMailingDripper < ::Caffeinate::Dripper::Base
        self.campaign = :skipped_mailing
        drip :happy, mailer_class: 'SkippedMailingMailer', delay: 0.hours, using: :parameterized
      end

      let!(:mailing_campaign) { create(:caffeinate_campaign, slug: :skipped_mailing) }
      let!(:skipped_subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: mailing_campaign) }

      class SkippedMailingMailer < ActionMailer::Base
        def happy
          mail(to: 'hello@example.com', from: 'hello@example.com', subject: 'hello') do |format|
            format.text { render plain: 'hi' }
          end
        end
      end

      it 'sets skipped to nil' do
        mailing = skipped_subscription.caffeinate_mailings.first
        mailing.skip!
        expect(mailing.skipped?).to be_truthy
        mailing.process!
        expect(mailing.skipped?).to be_falsey
        expect(mailing.sent?).to be_truthy
      end
    end
  end
end
