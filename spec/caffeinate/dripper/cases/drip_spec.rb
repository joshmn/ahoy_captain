# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Drip do
  class DripDripper < ::Caffeinate::Dripper::Base
    drip :test, delay: 0.hours, step: 1, mailer_class: 'CoolMailer'
  end

  context '.drip' do
    it 'registers a drip with valid arguments' do
      expect(DripDripper.drips.size).to eq(1)
      expect(DripDripper.drips.first.options).to eq({ delay: 0.hours, step: 1, mailer_class: 'CoolMailer', using: nil })
    end
  end

  context 'no delay' do
    it 'raises ArgumentError' do
      expect do
        DripDripper.drip :welcome
      end.to raise_error(ArgumentError)
    end
  end
end
