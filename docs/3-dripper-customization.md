---
redirect_from: /docs/3-dripper-customization.html
---

# Working with Drippers

Every Dripper corresponds to a `Caffeinate::Campaign` record. 

**Note:** If you don't have `implicit_campaigns` set to true in `Caffeinate::Config`, before using a Dripper you must first 
create a `Caffeinate::Campaign` record for it.

In a Rails console:

```
pry(main)> Caffeinate::Campaign.create(name: "Abandoned Cart", slug: "abandoned_cart")
```

Make sure you note the `slug` attribute. You will use this later.

## Creating the Dripper

Create a file in `app/drippers` called `abandoned_cart_dripper.rb`:

```ruby
class AbandonedCartDripper < ApplicationDripper
end
```

On the first line, you will want to specify what `Caffeinate::Campaign` record this campaign belongs to. By default,
we assume there is a `Caffeinate::Campaign` record with a slug of the class name without "Dripper", underscored. 

It's okay to be explicit though. Let's do that.

```ruby 
class AbandonedCartDripper < ApplicationDripper
  self.campaign = :abandoned_cart 
end
```

## Setting defaults

For this Campaign, we'll only be using the `AbandonedCartMailer` for each of the emails that we send. By default,
Caffeinate assumes the mailer is going to be the Dripper class name with the suffix "Dripper". We can set this as a default option
if we want to, too, just to remind other developers what they're working with.

```ruby 
class AbandonedCartDripper < ApplicationDripper
  self.campaign = :abandoned_cart
  default mailer: "AbandonedCartMailer"
end
``` 

## Defining Drips

Now that we have our Dripper associated to a `Caffeinate::Campaign`, and we set our defaults, we can start making defining
what drips are used in this Dripper.

The definition for a drip is as follows:

```ruby
drip <action_name> <options> <block>
```

Where `action_name` is the name of the ActionMailer action.

Options include:
* `mailer` (`String`) the class name of the `ActionMailer` class (also aliased to `mailer_class`); Required if not specified in the Dripper defaults
* `delay` (`ActiveSupport::Duration`) when to send the mail. This is most commonly used like `4.hours`. Required if `on` is not set
* `on` (`Time` or `Block` or `Symbol`) the exact date that the drip gets sent. Required if `delay` is not set 
* `at` (`String`) the specific time that the drip gets sent. Gets coerced into the date via `DateTime#change` 
* `step` (`Integer`) the order in which the drip is ran. Default is the order in which the the drip is defined

The `block` is optional. It executes in the context of the drip so you can access `mailing` within it.
 
If you `throw(:abort)`, the mail won't be sent (this time).

```ruby 
# Won't be sent if the time is even...?
drip :are_you_still_there, delay: 48.hours do 
  if Time.now.to_i.even?
    throw(:abort)
  end 
end 
```

You can also invoke `unsubscribe!`, `end!`, and `skip!` here to manage the subscription state and skip the mailing.

```ruby 
# Won't be sent if the time is even...?
drip :are_you_still_there, delay: 48.hours do 
  if mailing.subscription.subscriber.onboarding_completed?
    unsubscribe!("Completed onboarding")
  end 
end 
```

### Precision schedules

We can become more precise with our schedule. 

#### Sending at a specific time

Use `at`:

`drip :welcome, delay: 1.day, at: '12:00 PM America/New_York'`

At coerces the delay using `DateTime#change`.

#### Sending in the user's timezone

Use `on`:

```ruby 
class WelcomeDripper < ApplicationDripper
  self.campaign = :welcome
  default mailer: "WelcomeMailer"
  
  drip :created, on: :user_local_time
  drip :how_is_it_going, on: :user_local_time
  
  def user_local_time(drip, mailing)
    user = mailing.subscription.subscriber 
    offset = user.utf_offset.minutes
      
    if drip.action == :created 
      1.day.from_now - offset 
    elsif drip.action == :how_is_it_going
      3.days.from_now - offset 
    else
      raise ArgumentError, "no time for #{drip.inspect}"
    end   
  end
end   
```

## Handling subscribers

You can explicitly call `Caffeinate::CampaignSubscription` which is just an ActiveRecord model, or you can invoke the dripper:

 ```ruby
AbandonedCartDripper.subscribe(cart, user: cart.user)
```

The first argument will delegate to the `Caffeinate::CampaignSubscription#subscriber` (polymorphic association), the 
rest of the arguments delegate to `Caffeinate::CampaignSubscription`.

There's an optional `user` association which is also polymorphic. 

## Validating subscribers

You can offload the validation of a subscriber to a Dripper:

```ruby 
  before_subscribe do |campaign_subscription|
    campaign_subscription.errors.add(:base, "is invalid")
    throw(:abort)
  end
```

## Sending emails

Call `perform!` on the dripper. You'll probably do this in a background job and have it run every `x` minutes.

```ruby
AbandonedCartDripper.perform!
```

This looks at `Caffeinate::Mailing` records where `send_at` has past, `skipped_at` is nil, and the associated 
`Caffeinate::CampaignSubscription` is has empty `ended_at` and `unsubscribed_at` values.

## Callbacks

You probably want to know when some things happen. There's a list of [what yields what in the docs](https://rubydoc.info/gems/caffeinate/Caffeinate/Dripper/Callbacks).

## Writing your mailer

Your mailer is just like every other mailer. Except, your action only receives one argument: the `Caffeinate::CampaignSubscription#subscriber`.

```ruby 
class AbandonedCartMailer < ActionMailer::Base
  def are_you_still_there(mailer)
    @mailing = mailing
    @cart = mailing.subscriber
    @user = mailing.user 
    mail(to: @user.email, from: "you@example.com", subject: "You still there?")
  end 
end
```

Using `ActionMailer::Parameterized`? You'll need to make one small change to your drip:

```ruby
drip :are_you_still_there, delay: 48.hours, using: :parameterized 
```

We'll send down `@mailing` as the `Caffeinate::Mailing` object.

## Subscriptions

Now we need to handle subscription states.

Next is [Handling Subscriptions](4-handling-subscriptions.md).
