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

Now that we have our Campaign associated to a `Caffeinated::Campaign`, and we set our defaults, we can start making defining
what drips are used in this Campaign.

The definition for a drip is as follows:

```ruby
drip <action_name> <options> <block>
```

Options include:
* `delay` (`ActiveSupport::Duration`) (required) when to send the mail. This is most commonly used like `4.hours`
* `mailer` (`String`) the class name of the `ActionMailer` class (also aliased to `mailer_class`)
* `step` (`Integer`) the order in which the drip is ran. Default is the order in which the the drip is defined

The `block` is optional and if it returns `false` the mail will not be sent. An example block looks like this:

```ruby 
drip :are_you_still_there, delay: 48.hours do 
  if mailing.user.last_active_at > 4.hours.ago
    end!
    return false  
  end 
end 
```

You have a few options here to manage the mailing:
