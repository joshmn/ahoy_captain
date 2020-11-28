# frozen_string_literal: true

# == Schema Information
#
# Table name: caffeinate_campaign_subscriptions
#
#  id                     :integer          not null, primary key
#  caffeinate_campaign_id :integer          not null
#  subscriber_type        :string           not null
#  subscriber_id          :string           not null
#  user_type              :string
#  user_id                :string
#  token                  :string           not null
#  ended_at               :datetime
#  unsubscribed_at        :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :caffeinate_campaign_subscription, class: 'Caffeinate::CampaignSubscription' do
    caffeinate_campaign
    subscriber { create(:company) }
    user { create(:user) }
    token { SecureRandom.uuid }
  end

  trait :ready do
    association :caffeinate_campaign, factory: :prebuilt_caffeinate_campaign
  end
end
