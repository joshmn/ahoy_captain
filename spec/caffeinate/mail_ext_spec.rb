require 'rails_helper'

describe Mail::Message do
  context '#caffeinate?' do
    it 'is true if caffeinate_mailing is present' do
      message = Mail::Message.new
      message.caffeinate_mailing = 'hi'
      expect(message.caffeinate?).to be_truthy
    end
  end
end
