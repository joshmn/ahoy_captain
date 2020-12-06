# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Periodical do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'periodical_dripper') }

  class PeriodicalMailer < ApplicationMailer
    def welcome(_)
      mail(to: 'test@example.com', from: 'test@example.com', subject: 'hello') do |format|
        format.text { render plain: 'hello' }
      end
    end
  end

  class PeriodicalDripper < ::Caffeinate::Dripper::Base
    self.campaign = :periodical_dripper
    default mailer_class: 'PeriodicalMailer'

    periodical :welcome, every: 1.hour, start: proc { |thing| 0.hours }
  end

  context '.periodical' do
    let!(:campaign_subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }
    it 'has a single mailing' do
      expect(campaign_subscription.caffeinate_mailings.count).to eq(1)
    end
    context 'with performed dripper' do
      let(:perform) { PeriodicalDripper.perform! }
      it 'changes deliveries count' do
        expect {
          perform
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end

      it 'creates another mailing' do
        expect { perform }.to change(campaign_subscription.caffeinate_mailings, :count).by(1)
      end

      it 'creates an unsent mailing' do
        perform
        expect(campaign_subscription.caffeinate_mailings.unsent.count).to eq(1)
      end

      it 'sends a mail' do
        perform
        expect(campaign_subscription.caffeinate_mailings.unsent.first.send_at).to be_within(10.seconds).of(1.hour.from_now)
      end
    end
  end
end
