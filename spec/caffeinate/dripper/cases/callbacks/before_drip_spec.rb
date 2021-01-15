
require 'rails_helper'

describe ::Caffeinate::Dripper::Callbacks do
  describe 'before_drip' do
    let(:campaign) { create(:caffeinate_campaign, :with_dripper) }
    let(:dripper) { campaign.to_dripper }
    let(:company) { create(:company) }
    let(:subscription) { campaign.subscribe(company) }
    let(:mailing) { subscription.caffeinate_mailings.first }

    before do
      dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.hours

      dripper.class_eval do
        before_drip do |drip, mailing|
          unsubscribe!(mailing.subscriber)
          throw(:abort)
        end
      end
    end

    it 'does not send a mail since it gets unsubscribed' do
      subscription.reload
      expect {
        dripper.perform!
      }.to_not change(ActionMailer::Base.deliveries, :count)
    end
  end
end
