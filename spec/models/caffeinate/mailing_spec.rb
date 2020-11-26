require 'rails_helper'

describe ::Caffeinate::Mailing do
  let!(:campaign) { create(:caffeinate_campaign, slug: :caffeinate_active_record_extension) }
  let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
  let!(:unsent_mailings) { create_list(:caffeinate_mailing, 5, :unsent, caffeinate_campaign_subscription: subscription) }
  let!(:sent_mailings) { create_list(:caffeinate_mailing, 3, :sent, caffeinate_campaign_subscription: subscription) }
  let!(:skipped_mailings) { create_list(:caffeinate_mailing, 2, :skipped, caffeinate_campaign_subscription: subscription) }

  class CaffeinateMailingTestCampaign < ::Caffeinate::CampaignMailer::Base
    campaign :caffeinate_active_record_extension
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
        expect {
          mailing.process!
        }.to change {
          ActiveJob::Base.queue_adapter.enqueued_jobs.count
        }.by 1
        Caffeinate.config.mailing_job = nil
        Caffeinate.config.async_delivery = false
      end
    end
  end
end
