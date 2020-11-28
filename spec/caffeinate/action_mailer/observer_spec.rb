# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer::Observer do
  it 'is registered' do
    expect(Mail.class_variable_get(:@@delivery_notification_observers)).to include(described_class)
  end

  context '.delivered_email' do
    context 'without Caffeinate.current_mailing' do
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }
      it 'does nothing' do
        expect(Caffeinate.current_mailing).to be_falsey
        expect(described_class.delivered_email(mail)).to be_falsey
      end
    end

    context 'with Caffeinate.current_mailing' do
      let!(:campaign) { create(:caffeinate_campaign, :with_dripper) }
      let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
      before do
        campaign.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours
        campaign.to_dripper.after_send do
          @@after_send_called = true
        end
      end
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }
      let(:mailing) { subscription.caffeinate_mailings.first }
      it 'runs before_send callbacks' do
        ::Caffeinate.current_mailing = mailing
        described_class.delivered_email(mail)
        expect(campaign.to_dripper.class_variable_defined?(:@@after_send_called)).to be_truthy
      end

      it 'updates mailing to the current time' do
        ::Caffeinate.current_mailing = mailing
        expect do
          described_class.delivered_email(mail)
        end.to change(mailing, :sent_at)
      end
    end
  end
end
