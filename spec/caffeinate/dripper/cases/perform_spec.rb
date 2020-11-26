# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Perform do
  let!(:campaign) { create(:caffeinate_campaign, slug: 'perform_dripper') }

  class PerformMailer < ApplicationMailer
    def welcome(_)
      mail(to: 'test@example.com', from: 'test@example.com', subject: 'hello') do |format|
        format.text { render plain: 'hello' }
      end
    end
  end

  class PerformDripper < ::Caffeinate::Dripper::Base
    campaign :perform_dripper
    default mailer_class: 'PerformMailer'

    drip :welcome, delay: 1.hour
  end

  context '#perform' do
    let!(:campaign_subscription) { create(:caffeinate_campaign_subscription, caffeinate_campaign: campaign) }

    it 'sends a mail' do
      expect do
        PerformDripper.perform!
      end.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
