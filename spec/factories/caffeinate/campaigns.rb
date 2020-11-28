# frozen_string_literal: true

# == Schema Information
#
# Table name: caffeinate_campaigns
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :caffeinate_campaign, class: 'Caffeinate::Campaign' do
    sequence(:name) { |seq| "Campaign #{seq}" }
    sequence(:slug) { |seq| "campaign_#{seq}" }
  end

  trait :with_dripper do
    after(:create) do |obj|
      campaign_class_name = obj.name.gsub(' ', '')
      campaign_class = Object.const_set("#{campaign_class_name}Dripper", ::BaseTestDripper.clone)
      campaign_class.campaign(obj.slug.to_sym)
    end
  end

  trait :with_drips do
    after_create do |obj|
      obj.to_dripper.drip :hello, mailer_class: 'ArgumentMailer', delay: 0.minutes
    end
  end

  factory :prebuilt_caffeinate_campaign, parent: :caffeinate_campaign, traits: %i[with_dripper with_drips]
end
