# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer::Observer do
  it 'is registered' do
    expect(Mail.class_variable_get(:@@delivery_notification_observers)).to include(described_class)
  end

  describe '.delivered_email' do
    context 'without Mail::Message.caffeinate_mailing' do
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }

      it 'is not caffeinated' do
        expect(mail.caffeinate_mailing).to be_falsey
      end

      it 'returns false' do
        expect(described_class.delivered_email(mail)).to be_falsey
      end
    end

    context 'with Mail::Message.caffeinate_mailing' do
      let!(:campaign) { create(:caffeinate_campaign, :with_dripper) }
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }
      let(:mailing) { subscription.caffeinate_mailings.first }
      let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }

      before do
        campaign.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours
        campaign.to_dripper.after_send do
          @@after_send_called = true
        end
      end

      it 'runs before_send callbacks' do
        mail.caffeinate_mailing = mailing
        described_class.delivered_email(mail)
        expect(campaign.to_dripper).to be_class_variable_defined(:@@after_send_called)
      end

      it 'updates mailing to the current time' do
        mail.caffeinate_mailing = mailing
        expect do
          described_class.delivered_email(mail)
        end.to change(mailing, :sent_at)
      end
    end
  end
end
