# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Drip do
  class DripDripper < ::Caffeinate::Dripper::Base
    drip :test, delay: 0.hours, step: 1, mailer_class: 'CoolMailer'
  end

  describe '.drip' do
    it 'has a drips count' do
      expect(DripDripper.drips.size).to eq(1)
    end

    it 'registers a drip with valid arguments' do
      expect(DripDripper.drips.first.options).to eq({ delay: 0.hours, step: 1, mailer_class: 'CoolMailer', using: nil })
    end
  end

  context 'strings as keys' do
    it 'converts to symbols' do
      DripDripper.drip 'test_two', 'delay': 0.hours, 'step': 1, 'mailer_class': 'CoolMailer'
      expect(DripDripper.drip_collection.for(:test_two).options).to eq({ delay: 0.hours, step: 1, mailer_class: 'CoolMailer', using: nil })
    end
  end

  context 'no delay' do
    it 'raises ArgumentError' do
      expect do
        DripDripper.drip :welcome
      end.to raise_error(ArgumentError)
    end
  end

  context 'at: option' do
    it 'creates the drip at the time' do
      DripDripper.drip :welcome, delay: 3.days, at: "6:13:04 PM Eastern", mailer_class: 'Fun'
      time = DripDripper.drip_collection.for(:welcome).send_at.to_time
      expect(time.min).to eq(13)
      expect(time.sec).to eq(4)
      expect(time.hour).to eq(18)
    end
  end
end
