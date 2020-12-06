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
`Caffeinate::Mailing` manually, or if it gets otherwise triggered to be sent, a `Caffeinate::InvalidState` 
error will be raised if the associated `CampaignSubscription` is ended.

`#end!` takes an optional single argument of a string that will update the `CampaignSubscription#ended_reason` column.
 
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
`Caffeinate::InvalidState` if the associated `CampaignSubscription` is unsubscribed.

`#end!` takes an optional single argument of a string that will update the `CampaignSubscription#unsubscribe_reason` column.

## Resubscribing a Subscription

To resubscribe a subscription, simply call `resubscribe!`. 

```ruby 
subscription = Caffeinate::CampaignSubscription.first
subscription.resubscribe!
```

This will update the `unsubscribed_at` state to `nil`. If the subscription isn't unsubscribed, it will raise
`Caffeinate::InvalidState`.

This doesn't renew any drippings, instead just starts from the new time and any previously unsent `Mailing` that were 
supposed to be sent will be sent. This is probably a problem that I'd accept a PR for.

## Unsubscribe and Subscribe URLs

Caffeinate provides `caffeinate_unsubscribe_url` and `caffeinate_unsubscribe_path` to `ActionMailer::Base`
and `ActionView::Base`. They respect Rails' `default_url_options`, too.

You can pull in these helpers yourself by `include Caffeinate::Helpers`.

Additionally, you can use `Caffeinate::UrlHelpers` for quick and easy access to `Caffeinate::Helpers`.
