# frozen_string_literal: true

FactoryBot.define do
  factory :caffeinate_mailing, class: 'Caffeinate::Mailing' do
    caffeinate_campaign_subscription
    mailer_class { "MailerDoesNotExist" }
    mailer_action { "action_does_not_exist" }
  end

  trait :upcoming do
    send_at { 1.minute.from_now }
  end

  trait :sent do
    sent_at { Time.current }
  end

  trait :unsent do
    sent_at { nil }
  end

  trait :skipped do
    skipped_at { Time.current }
  end
end
