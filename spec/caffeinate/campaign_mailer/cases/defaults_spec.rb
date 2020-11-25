# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::CampaignMailer::Defaults do
  class DefaultsCampaignMailer < ::Caffeinate::CampaignMailer::Base
    default mailer_class: 'Bob'
  end

  context '.defaults' do
    it 'sets the defaults' do
      expect(DefaultsCampaignMailer.defaults).to eq({ mailer_class: 'Bob' })
    end
  end
end
