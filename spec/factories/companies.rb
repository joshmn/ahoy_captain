FactoryBot.define do
  factory :company do {}; end
  trait :with_user do
    user
  end
end
