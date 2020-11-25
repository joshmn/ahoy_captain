# frozen_string_literal: true

FactoryBot.define do
  factory :company do {}; end
  trait :with_user do
    user
  end
end
