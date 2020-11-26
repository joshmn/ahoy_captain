# frozen_string_literal: true

require 'rails_helper'

describe ::Caffeinate::Dripper::Defaults do
  class DefaultsDripper < ::Caffeinate::Dripper::Base
    default mailer_class: 'Bob'
  end

  context '.defaults' do
    it 'sets the defaults' do
      expect(DefaultsDripper.defaults).to eq({ mailer_class: 'Bob' })
    end
  end
end
