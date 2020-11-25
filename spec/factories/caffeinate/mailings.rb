FactoryBot.define do
  factory :caffeinate_mailing, class: "Caffeinate::Mailing" do
    caffeinate_campaign_subscription
  end
end
