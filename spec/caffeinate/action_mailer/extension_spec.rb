# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer::Extension do
  it 'includes the extension' do
    expect(::ActionMailer::Base.included_modules).to include(described_class)
  end

  context 'parameterized mailer' do
    let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }

    class CaffeinateActionMailerExtensionMailer < ::ActionMailer::Base
      def hello
        mail(to: 'hello@example.com', from: 'hello@example.com', subject: @mailing) do |format|
          format.text { render plain: 'hi' }
        end
      end
    end

    it 'receives @mailing' do
      expect(CaffeinateActionMailerExtensionMailer.with(mailing: 'Hello this is Bob').hello.subject).to eq('Hello this is Bob')
    end
  end

  context 'helpers' do
    let(:campaign) { create(:caffeinate_campaign, :with_dripper) }
    let(:company) { create(:company) }
    let(:subscription) { campaign.subscribe(company) }

    describe '#caffeinate_unsubscribe_url' do
      it 'returns a url' do
        url = CaffeinateActionMailerExtensionMailer.new.send(:caffeinate_unsubscribe_url, mailing: OpenStruct.new(caffeinate_campaign_subscription: subscription))
        expect(url).to eq("http://localhost:3000/caffeinate/campaign_subscriptions/#{subscription.token}/unsubscribe")
      end

      it 'handles passed options' do
        url = CaffeinateActionMailerExtensionMailer.new.send(:caffeinate_subscribe_url, mailing: OpenStruct.new(caffeinate_campaign_subscription: subscription), host: 'donkey.kong')
        expect(URI.parse(url).host).to eq('donkey.kong')
      end
    end

    describe '#caffeinate_subscribe_url' do
      it 'returns a url' do
        url = CaffeinateActionMailerExtensionMailer.new.send(:caffeinate_subscribe_url, mailing: OpenStruct.new(caffeinate_campaign_subscription: subscription))
        expect(url).to eq("http://localhost:3000/caffeinate/campaign_subscriptions/#{subscription.token}/subscribe")
      end

      it 'handles passed options' do
        url = CaffeinateActionMailerExtensionMailer.new.send(:caffeinate_subscribe_url, mailing: OpenStruct.new(caffeinate_campaign_subscription: subscription), host: 'donkey.kong')
        expect(URI.parse(url).host).to eq('donkey.kong')
      end
    end
  end
end
