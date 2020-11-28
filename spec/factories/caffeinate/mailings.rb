# frozen_string_literal: true

# == Schema Information
#
# Table name: caffeinate_mailings
#
#  id                                  :integer          not null, primary key
#  caffeinate_campaign_subscription_id :integer          not null
#  send_at                             :datetime
#  sent_at                             :datetime
#  skipped_at                          :datetime
#  mailer_class                        :string           not null
#  mailer_action                       :string           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
FactoryBot.define do
  factory :caffeinate_mailing, class: 'Caffeinate::Mailing' do
    caffeinate_campaign_subscription
    mailer_class { 'MailerDoesNotExist' }
    mailer_action { 'action_does_not_exist' }
  end

  trait :ready_to_mail do
    send_at { 1.minute.ago }
    mailer_class { 'ArgumentMailer' }
    mailer_action { 'hello' }
    association :caffeinate_campaign_subscription, :ready
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
