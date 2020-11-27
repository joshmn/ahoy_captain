# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer do
  class HelpersTestMailer < ::ActionMailer::Base
    before_action do
      @mailing = params[:mailing]
    end
    def hello
      mail do |format|
        format.text { render plain: caffeinate_unsubscribe_url }
      end
    end
  end

  context 'it works' do
    it 'works' do
      subscription = build_stubbed(:caffeinate_campaign_subscription)
      mailing = ::Caffeinate::Mailing.new(caffeinate_campaign_subscription: subscription)
      subscription.token = 'jesus'
      expect(HelpersTestMailer.with(mailing: mailing).hello.body.to_s).to eq('http://localhost:3000/caffeinate/campaign_subscriptions/jesus/unsubscribe')
    end
  end
end
