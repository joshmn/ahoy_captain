# Using associations

Congratulations, everything should be setup! Now the fun-ner parts.

## Showing a user their subscriptions

Depending on what a `User` is to your application you may have two different scenarios:

1. To a `CampaignSubscription` as a `Subscriber` — this option is used if you have a `Company` that has many `User` 
who you wish to subscribe to a Campaign.

```ruby 
class User < ApplicationRecord
  acts_as_caffeinate_subscriber
end 
```

will give you:

```ruby 
User.first.caffeinate_campaign_subscriptions
User.first.caffeinate_campaigns
User.first.caffeinate_mailings
```

2. Where a `User` is the `User` on `Caffeinate::CampaignSubscription`.

```ruby 
class User 
  acts_as_caffeinate_user
end 
```

will give you: 

```ruby 
User.first.caffeinate_campaign_subscriptions_as_user
User.first.caffeinate_campaigns_as_user
User.first.caffeinate_mailings_as_user
```

