require 'rails_helper'

describe Caffeinate::ActionMailer::Extension do
  it 'includes the extension' do
    expect(::ActionMailer::Base.included_modules).to include(described_class)
  end

  context 'parameterized mailer' do
    class CaffeinateActionMailerExtensionMailer < ::ActionMailer::Base
      def test
        mail(to: "hello@example.com", from: "hello@example.com", subject: @mailing) do |format|
          format.text { render plain: "hi" }
        end
      end
    end

    it 'receives @mailing' do
      Thread.current[:current_caffeinate_mailing] = "Hello this is Bob"
      expect(CaffeinateActionMailerExtensionMailer.test.subject).to eq("Hello this is Bob")
    end
  end
end
