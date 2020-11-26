---
redirect_from: /docs/3-campaign-customization.html
---

# Working with Campaigns

Every Campaign resource corresponds to a `Caffeinate::Campaign` record. So before creating a
CampaignMailer resource you must first create a `Caffeinate::Campaign` record for it.

## Creating a `Caffeinate::Campaign` Record

In a Rails console:

```
pry(main)> Caffeinate::Campaign.create(name: "Abandoned Cart", slug: "abandoned_cart")
```

**Note**: Make sure you note the `slug` attribute. You will use this later.

## Creating the Campaign

Create a file in `app/campaigns` called `abandoned_cart_campaign.rb`:

```ruby
class AbandonedCartCampaign < ApplicationCampaign
end 
```

On the first line, you will want to specify what `Caffeinate::Campaign` record this campaign belongs to. By default,
we assume there is a `Caffeinate::Campaign` record with a slug of the class name without "Campaign", underscored. 

It's okay to be explicit though. Let's do that.

```ruby 
class AbandonedCartCampaign < ApplicationCampaign
  campaign :abandoned_cart 
end
```

## Setting defaults

For this Campaign, we'll only be using the `AbandonedCartCampaignMailer` for each of the emails that we send. By default,
Caffeinate assumes the mailer is going to be the class name with the suffix "Mailer". We can set this as a default option
if we want to, too, just to remind other developers what they're working with.

```ruby 
class AbandonedCartCampaign < ApplicationCampaign
  campaign :abandoned_cart
  default mailer: "AbandonedCartCampaignMailer"
end
``` 

## Defining Drips

Now that we have our Campaign associated to a `Caffeinate::Campaign`, and we set our defaults, we can start making defining
what drips are used in this Campaign.

The definition for a drip is as follows:

```ruby
drip <action_name> <options> <block>
```

Where `action_name` is the name of the ActionMailer action.

Options include:
* `delay` (`ActiveSupport::Duration`) (required) when to send the mail. This is most commonly used like `4.hours`
* `mailer` (`String`) the class name of the `ActionMailer` class (also aliased to `mailer_class`)
* `step` (`Integer`) the order in which the drip is ran. Default is the order in which the the drip is defined

The `block` is optional. It executes in the context of the drip so you can access `mailing` within it. If it returns 
`false`, the mail will not be sent. An example block looks like this:

```ruby 
drip :are_you_still_there, delay: 48.hours do 
  if mailing.user.last_active_at > 4.hours.ago
    end!
    return false  
  end 
  true 
end 
```

You have a few options here to manage the mailing:
* `end!` will update the associated `Caffeinate::CampaignSubscription`'s `ended_at`
* `unsubscribe!` will update the associated `Caffeinate::CampaignSubscription`'s `unsubscribed_at`
* `skip!` will update the associated `Caffeinate::Mailer`'s `skipped_at`

Returning `false` without calling any of these will not send the mailer _now_ but will retry when it the `perform` method gets called again. Speaking of...

## Handling subscribers

There are two ways of handling subscribers. 

### Do it yourself

```ruby
AbandonedCartCampaign.subscribe(cart, user: cart.user)
```

### Automate it

```ruby
class AbandonedCartCampaign < ApplicationCampaign
  campaign :abandoned_cart
  default mailer: "AbandonedCartCampaignMailer"
  
  drip :are_you_still_there, delay: 48.hours do 
    if mailing.user.last_active_at > 4.hours.ago
      end!
      return false  
    end 
    true 
  end 

  subscribes do 
    Cart.includes(:user)
        .where('cart_items_count > 0')
        .where(completed_at: nil)
        .where(started_at: 3.days.ago..2.days.ago).each do |cart|
      subscribe(cart, user: cart.user)
    end
  end 
end
```

Put this in a background process and run it every `n` minutes. 60 minutes works for me, it should work for you:

```ruby
AbandonedCartCampaign.subscribe!
```

Though, each campaign might run at a different pace.

Don't worry about duplicate subscribers. `subscribe` calls `Caffeinate::Campaign#subscribe` which does a `find_or_create_by`.

Now since you have drips and subscribers, let's send some emails.

## Sending emails

It's easy. 

Put this in a background job and have it run every `x` minutes. 5 minutes works for me, it should work for you:

```ruby
AbandonedCartCampaign.perform!
```

You're done.

## Callbacks

You probably want to know when some things happen. Here's the lifecycle:

### on_subscribe
 
Gets called when a `Caffeinate::CampaignSubscription` is created, and after its mailings are created. 

### before_send

Gets called in an ActionMailer interceptor before the mail is sent.

### after_send

Gets called in the observer after the mail is sent.

### on_complete

Gets called after the a `Caffeinate::CampaignSubscription` completes a campaign.

### on_unsubscribe

Gets called after the a `Caffeinate::CampaignSubscription` unsubscribes from a campaign using `Caffeinate::CampaignSubscription#unsubscribe!`.

### on_skip

Gets called after the `Caffeinate::Mailing#skip!` is called.

## Writing your mailer

Your mailer is just like every other mailer. Except, your action only receives one argument: the `Caffeinate::CampaignSubscription#subscriber`.

```ruby 
class AbandonedCartCampaignMailer < ActionMailer::Base

  def are_you_still_there(cart)
    @cart = cart 
    mail(to: @cart.user.email, from: "you@example.com", subject: "You still there?")
  end 
end
```
