require 'rails_helper'

describe Caffeinate::Dripper::DripCollection do
  let(:dripper) { create(:caffeinate_campaign, :with_dripper).to_dripper }
  let(:collection) { described_class.new(dripper) }
  context '#each' do
    it 'yields' do
      expect(collection.each).to be_a(Enumerable)
    end
  end

  context '#size' do
    it 'delegate to @drips' do
      expect(collection.size).to eq(collection.instance_variable_get(:@drips).size)
    end
  end

  context '#[]' do
    it 'delegate to @drips' do
      expect(collection[:key]).to eq(collection.instance_variable_get(:@drips)[:key])
    end
  end

  context '#validate_drip_options' do
    it 'raises argument error if invalid' do
      error = begin
                collection.send(:validate_drip_options, :name, {mailer_class: "Test"})
              rescue => e
                e
              end
      expect(error.class).to eq(ArgumentError)
      expect(error.message).to include(":delay")
    end
  end
end
