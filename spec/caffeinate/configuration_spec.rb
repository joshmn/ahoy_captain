# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::Configuration do
  describe '#now=' do
    it 'raises an error if does not respond to call' do
      expect do
        described_class.new.now = 'bad'
      end.to raise_error(ArgumentError)
    end

    it 'supers if it is valid' do
      instance = described_class.new
      value = proc { Time.now }
      Timecop.freeze do
        instance.now = value
        expect(instance.now.call).to eq(value.call)
      end
    end
  end
end
