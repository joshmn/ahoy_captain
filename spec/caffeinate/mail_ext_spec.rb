# frozen_string_literal: true

require 'rails_helper'

describe Mail::Message do
  describe '#caffeinate?' do
    it 'is true if caffeinate_mailing is present' do
      message = described_class.new
      message.caffeinate_mailing = 'hi'
      expect(message).to be_caffeinate
    end
  end
end
