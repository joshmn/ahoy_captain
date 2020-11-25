require 'rails_helper'

describe Caffeinate::Drip do
  context '#parameterized?' do
    it 'is true if using: :parameterized' do
      drip = described_class.new(nil, nil, using: :parameterized)
      expect(drip.parameterized?).to be_truthy
      drip = described_class.new(nil, nil, using: :asdf)
      expect(drip.parameterized?).to be_falsey
    end
  end
end
