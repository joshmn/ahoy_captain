FactoryBot.define do
  factory :caffeinate_campaign, class: "Caffeinate::Campaign" do
    sequence(:name) { |seq| "Campaign #{seq}" }
    sequence(:slug) { |seq| "campaign_#{seq}" }
  end
end
