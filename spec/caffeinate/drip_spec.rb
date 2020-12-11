# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::Drip do
  describe '#parameterized?' do
    it 'is true if using: :parameterized' do
      drip = described_class.new(nil, nil, using: :parameterized)
      expect(drip).to be_parameterized
      drip = described_class.new(nil, nil, using: :asdf)
      expect(drip).not_to be_parameterized
    end
  end

  describe '#send_at' do
    it 'is a time' do
      drip = described_class.new(nil, nil, delay: 3.hours)
      expect(drip.send_at).to be_a(::ActiveSupport::TimeWithZone)
      expect(drip.send_at.to_i).to eq(3.hours.from_now.to_i)
    end
  end

  describe '#enabled?' do
    it 'works' do
      drip = described_class.new(nil, nil, {})
      expect(drip).to respond_to(:enabled?)
    end
  end
end
