# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::CampaignMailer::Delivery do
  class DeliveryTestMailer < ActionMailer::Base
    before_action do
      @thing = '123'
    end

    def welcome
      mail(to: 'hello@example.com', from: 'bob@example.com', subject: 'sup') do |format|
        format.text { render plain: 'Hi' }
      end
    end

    def with_params
      mail(to: 'hello@example.com', from: 'hello@examle.com', subject: @thing) do |format|
        format.text { render plain: 'hi' }
      end
    end

    def goodbye
      mail(to: 'hello@example.com', from: 'bob@example.com', subject: 'sup') do |format|
        format.text { render plain: 'Hi' }
      end
    end
    alias goodbye_end goodbye
    alias goodbye_unsubscribe goodbye
  end

  class DeliveryTestCampaignMailer < ::Caffeinate::CampaignMailer::Base
    campaign :delivery_test_campaign_mailer

    default mailer_class: 'DeliveryTestMailer'

    drip :welcome, delay: 0.hours
    drip :with_params, delay: 0.hours, using: :parameterized
    drip :goodbye, delay: 0.hours do
      false
    end

    drip :goodbye_end, delay: 0.hours do
      end!
    end

    drip :goodbye_unsubscribe, delay: 0.hours do
      unsubscribe!
    end
  end

  let(:campaign) { create(:caffeinate_campaign, slug: 'delivery_test_campaign_mailer') }
  let(:campaign_subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
  let(:mailing) { create(:caffeinate_mailing, caffeinate_campaign_subscription: campaign_subscription, mailer_class: 'DeliveryTestMailer', mailer_action: 'welcome') }

  context '.deliver!' do
    it 'sends it' do
      expect(mailing.sent_at).to be_nil
      expect do
        DeliveryTestCampaignMailer.deliver!(mailing)
      end.to change(::ActionMailer::Base.deliveries, :size).by(1)
      expect(mailing.sent_at).to be_present
    end
  end

  context '.deliver! with parameterized' do
    let(:mailing) { create(:caffeinate_mailing, caffeinate_campaign_subscription: campaign_subscription, mailer_class: 'DeliveryTestMailer', mailer_action: 'with_params') }
    it 'using parameterized' do
      expect(mailing.sent_at).to be_nil
      expect do
        DeliveryTestCampaignMailer.deliver!(mailing)
      end.to change(::ActionMailer::Base.deliveries, :size).by(1)
      expect(mailing.sent_at).to be_present
      expect(::ActionMailer::Base.deliveries.last.subject).to eq('123')
    end
  end

  shared_examples_for 'block that returns false' do
    it 'does not send' do
      expect(mailing.sent_at).to be_nil
      expect do
        do_action
      end.to_not change(::ActionMailer::Base.deliveries, :size)
      expect(mailing.sent_at).to be_nil
      mailing.caffeinate_campaign_subscription.reload
    end
  end

  shared_examples_for 'block that returns false and unsubscribes' do
    it 'does not send' do
      expect(mailing.sent_at).to be_nil
      expect do
        do_action
      end.to_not change(::ActionMailer::Base.deliveries, :size)
      expect(mailing.sent_at).to be_nil
      mailing.caffeinate_campaign_subscription.reload
    end
  end

  context 'with a block that returns false' do
    let(:mailing) { create(:caffeinate_mailing, caffeinate_campaign_subscription: campaign_subscription, mailer_class: 'DeliveryTestMailer', mailer_action: 'goodbye') }
    let(:do_action) { DeliveryTestCampaignMailer.deliver!(mailing) }
    it_behaves_like 'block that returns false'
  end

  context 'with a block that returns false' do
    let(:mailing) { create(:caffeinate_mailing, caffeinate_campaign_subscription: campaign_subscription, mailer_class: 'DeliveryTestMailer', mailer_action: 'goodbye_end') }
    let(:do_action) { DeliveryTestCampaignMailer.deliver!(mailing) }
    it_behaves_like 'block that returns false and unsubscribes'
  end
end
