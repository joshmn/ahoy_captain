require 'rails_helper'

describe Caffeinate::Configuration do
  context '#now=' do
    it 'raises an error if does not respond to call' do
      expect {
        described_class.new.now = "bad"
      }.to raise_error(ArgumentError)
    end

    it 'supers if it is valid' do
      instance = described_class.new
      value = Proc.new { Time.now }
      Timecop.freeze do
        instance.now = value
        expect(instance.now.call).to eq(value.call)

      end
    end
  end
end
