# frozen_string_literal: true

require 'rails_helper'

describe Caffeinate::ActionMailer::Extension do
  it 'includes the extension' do
    expect(::ActionMailer::Base.included_modules).to include(described_class)
  end

  context 'parameterized mailer' do
    let(:mail) { Mail.from_source("Date: Fri, 28 Sep 2018 11:08:55 -0700\r\nTo: a@example.com\r\nMime-Version: 1.0\r\nContent-Type: text/plain\r\nContent-Transfer-Encoding: 7bit\r\n\r\nHello!") }

    class CaffeinateActionMailerExtensionMailer < ::ActionMailer::Base
      def hello
        mail(to: 'hello@example.com', from: 'hello@example.com', subject: @mailing) do |format|
          format.text { render plain: 'hi' }
        end
      end
    end

    it 'receives @mailing' do
      expect(CaffeinateActionMailerExtensionMailer.with(mailing: 'Hello this is Bob').hello.subject).to eq('Hello this is Bob')
    end
  end
end
