FactoryBot.define do
  factory :caffeinate_campaign_subscription, class: "Caffeinate::CampaignSubscription" do
    caffeinate_campaign
    subscriber { create(:company) }
    user { create(:user) }
  end
end
