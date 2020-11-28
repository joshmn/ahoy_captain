require 'rails_helper'

describe Caffeinate::ActionMailer::Interceptor do
  it 'is registered' do
    expect(Mail.class_variable_get(:@@delivery_interceptors)).to include(described_class)
  end

  context '.delivering_email' do
    context 'without Caffeinate.current_mailing' do
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!")  }
      it 'does nothing' do
        expect(Caffeinate.current_mailing).to be_falsey
        expect(described_class.delivering_email(mail)).to be_falsey
      end
      it 'does not change #perform_deliveries' do
        expect {
          described_class.delivering_email(mail)
        }.to_not change(mail, :perform_deliveries)
      end
    end

    context 'with Caffeinate.current_mailing' do
      let!(:campaign) { create(:caffeinate_campaign, :with_dripper) }
      let(:subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
      before do
        campaign.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours
        campaign.to_dripper.before_send do
          @@before_send_called = true
        end
      end
      let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!")  }
      let(:mailing) { subscription.caffeinate_mailings.first }
      it 'runs before_send callbacks' do
        ::Caffeinate.current_mailing = mailing
        described_class.delivering_email(mail)
        expect(campaign.to_dripper.class_variable_defined?(:@@before_send_called)).to be_truthy
      end

      it 'sets performed_deliveries to the result of the evaluator' do
        drips = campaign.to_dripper.drip_collection
        campaign.to_dripper.instance_variable_set(:@drip_collection, ::Caffeinate::Dripper::Drip::DripCollection.new(campaign.to_dripper))
        campaign.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours do
          false
        end
        ::Caffeinate.current_mailing = mailing
        described_class.delivering_email(mail)
        expect(mail.perform_deliveries).to be_falsey
        campaign.to_dripper.instance_variable_set(:@drip_collection, drips)
      end
    end
  end
end
