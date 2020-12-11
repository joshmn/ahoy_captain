# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer::Interceptor do
  it 'is registered' do
    expect(Mail.class_variable_get(:@@delivery_interceptors)).to include(described_class)
  end

  describe '.delivering_email' do
    context 'without Mail::Message.caffeinate_mailing' do
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }

      it 'is not caffeinate_mailing' do
        expect(mail.caffeinate_mailing).to be_falsey
      end

      it 'does not deliver' do
        expect(described_class.delivering_email(mail)).to be_falsey
      end

      it 'does not change #perform_deliveries' do
        expect do
          described_class.delivering_email(mail)
        end.not_to change(mail, :perform_deliveries)
      end
    end

    context 'with Mail::Message.caffeinate_mailing' do
      let!(:campaign) { create(:caffeinate_campaign, :with_dripper) }
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }
      let(:mailing) { subscription.caffeinate_mailings.first }
      let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }

      before do
        campaign.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours
        campaign.to_dripper.before_send do
          @@before_send_called = true
        end
      end

      it 'runs before_send callbacks' do
        mail.caffeinate_mailing = mailing
        described_class.delivering_email(mail)
        expect(campaign.to_dripper).to be_class_variable_defined(:@@before_send_called)
      end

      it 'sets performed_deliveries to the result of the evaluator' do
        drips = campaign.to_dripper.drip_collection
        campaign.to_dripper.instance_variable_set(:@drip_collection, ::Caffeinate::Dripper::DripCollection.new(campaign.to_dripper))
        campaign.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours do
          false
        end
        mail.caffeinate_mailing = mailing
        described_class.delivering_email(mail)
        expect(mail.perform_deliveries).to be_falsey
        campaign.to_dripper.instance_variable_set(:@drip_collection, drips)
      end
    end
  end
end
