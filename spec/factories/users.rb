FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}@example.com" }
  end
end
