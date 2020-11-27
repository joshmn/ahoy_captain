---
redirect_from: /docs/4-handling-subscriptions.html
---

# Handling Subscriptions

Now that you have a Dripper setup, you'll want to give people a way to opt-out of your emails.

## Ending a Subscription

To end a subscription usually indicates that the user performed an action and the Dripper is no longer relevant to them.

To end a subscription, simply call `end!`. 

```ruby 
subscription = Caffeinate::CampaignSubscription.first
subscription.end!
```

When a Dripper runs, it excludes all `CampaignSubscription` which are either ended or unsubscribed. If you try sending a 
`Caffeinate::Mailing` manually, or if it gets otherwise triggered to be sent, a `Caffeinate::CampaignSubscriptionEnded` 
error will be raised if the associated `CampaignSubscription` is ended.

## Unsubscribing a Subscription

To unsubscribe is to cancel all future `Caffeinate::Mailing` records from getting sent. They don't get deleted, they 
just aren't pulled in when the Dripper runs. 

To unsubscribe a subscription, simply call `unsubscribe!`. 

```ruby 
subscription = Caffeinate::CampaignSubscription.first
subscription.unsubscribe!
```

When a Dripper runs, it excludes all `CampaignSubscription` which are either ended or unsubscribed. If you try sending a 
`Caffeinate::Mailing` manually, or if it gets otherwise triggered to be sent, it will raise 
`Caffeinate::CampaignSubscriptionUnsubscribed` if the associated `CampaignSubscription` is unsubscribed.

## Resubscribing a Subscription

**Note**: This method is a work in progress and is not available yet.

To resubscribe a subscription, simply call `resubscribe!`. 

```ruby 
subscription = Caffeinate::CampaignSubscription.first
subscription.resubscribe!
```

This will update the `unsubscribed_at` state to `nil`. If the subscription isn't unsubscribed, it will raise
`Caffeinate::CampaignSubscription::InvalidState`.

## Resuming a Subscription

**Note**: This method is a work in progress and is not available yet.

To resume a subscription, simply call `resume!`. 

```ruby 
subscription = Caffeinate::CampaignSubscription.first
subscription.resume!
```

This will update the `ended_at` state to `nil`. If the subscription isn't ended, it will raise
`Caffeinate::CampaignSubscription::InvalidState`.

## Unsubscribe and Subscribe URLs

Caffeinate provides `caffeinate_unsubscribe_url` and `caffeinate_unsubscribe_path` to `ActionMailer::Base`
and `ActionView::Base`. They respect Rails' `default_url_options`, too.

You can pull in these helpers yourself by `include Caffeinate::Helpers`.
