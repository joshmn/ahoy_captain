# frozen_string_literal: true

FactoryBot.define do
  factory :caffeinate_campaign, class: 'Caffeinate::Campaign' do
    sequence(:name) { |seq| "Campaign #{seq}" }
    sequence(:slug) { |seq| "campaign_#{seq}" }
  end

  trait :with_campaign do
    after(:create) do |obj|
      campaign_class_name = obj.name.gsub(' ', '')
      campaign_class = Object.const_set(campaign_class_name, ::TestCampaign.clone)
      campaign_class.campaign(obj.slug.to_sym)
    end
  end
end
