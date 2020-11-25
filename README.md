# Caffeinate

A drip mailer and management for Ruby on Rails.

## Usage

Given a mailer like this:

```ruby 
class AbandonedCartMailer < ActionMailer::Base 
  def you_forgot_something(cart)
    mail(to: cart.user.email, subject: "You forgot something!")
  end

  def selling_out_soon(cart)
    mail(to: cart.user.email, subject: "Selling out soon!")
  end 
end 
```

### Create a Campaign

```ruby 
Caffeinate::Campaign.create!(name: "Abandoned Cart", slug: "abandoned_cart") 
```

### Create a Caffeinated::CampaignMailer

```ruby 
class AbandonedCartCampaignMailer < Caffeinated::CampaignMailer
  # This should match a Caffeinate::Campaign#slug
  campaign :abandoned_cart 
  
  # A block to subscribe your users automatically 
  # You can invoke this by calling `AbandonedCartCampaignMailer.subscribe!`,
  # probably in a background process, run at a given interval 
  subscribing do 
    Cart.left_joins(:cart_items)
        .includes(:user)
        .where(completed_at: nil)
        .where(updated_at: 1.day.ago..2.days.ago)
        .having('count(cart_items.id) = 0').each do |cart|
      subscribe(cart, user: cart.user)
    end 
  end 
  
  # Register your drips! Syntax is
  # drip <mailer_action_name>, mailer_class: <MailerClass>, delay: <ActiveSupport::Interval>
  drip :you_forgot_something, mailer: "AbandonedCartMailer", delay: 1.hour 
  drip :selling_out_soon, mailer: "AbandonedCartMailer", delay: 8.hours do 
    cart = mailing.subscriber
    if cart.completed?
      end! # you can also invoke `unsubscribe!`, `skip!`, or otherwise return `false` to not do this mailing
      return false
    end 
  end 
end 
```

And then run run your campaign:

```ruby 
AbandonedCartCampaignMailer.perform!
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'caffeinate'
```

And then do the bundle:

```bash
$ bundle
```

Add do some housekeeping:

```bash
$ rails g caffeinate:install 
```

Followed by a migrate:

```bash
$ rails db:migrate
```

## Upcoming features

* Ability to optionally use relative time when creating a step 

## Contributing

Just do it.

## Contributors & thanks

* Thanks to [sourdoughdev](https://github.com/sourdoughdev/caffeinate) for releasing the gem name to me. :) 
 
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
