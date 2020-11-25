require 'rails_helper'

describe ::Caffeinate::CampaignMailer::Drip do
  class DripCampaignMailer < ::Caffeinate::CampaignMailer::Base
    drip :test, delay: 0.hours, step: 1, mailer_class: "CoolMailer"
  end

  context '.drip' do
    it 'registers a drip with valid arguments' do
      expect(DripCampaignMailer.drips.size).to eq(1)
      expect(DripCampaignMailer.drips.first.options).to eq({delay: 0.hours, step: 1, mailer_class: "CoolMailer"})
    end
  end

  context 'no delay' do
    it 'raises ArgumentError' do
      expect {
        DripCampaignMailer.drip :welcome
      }.to raise_error(ArgumentError)
    end
  end
end
