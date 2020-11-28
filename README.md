# Caffeinate

Caffeinate is a drip campaign engine for Ruby on Rails applications.

Caffeinate tries to make creating and managing timed and scheduled email sequences fun. It works alongside ActionMailer 
and has everything you need to get started and to successfully manage campaigns. It's only dependency is the stack you're
already familiar with: Ruby on Rails.

## Usage

You can probably imagine seeing a Mailer like this:

```ruby 
class OnboardingMailer < ActionMailer::Base 
  # Send on account creation
  def welcome_to_my_cool_app(user)
    mail(to: user.email, subject: "You forgot something!")
  end

  # Send 2 days after the user signs up
  def some_cool_tips(user)
    mail(to: user.email, subject: "Here are some cool tips for MyCoolApp")
  end 

  # Sends 3 days after the user signs up and hasn't added a company profile yet
  def help_getting_started(user)
    return if user.company.present?

    mail(to: user.email, subject: "Did you know...")
  end 
end 
```

With background jobs running, checking, and everything else. That's messy. Why are we checking state in the Mailer? Ugh.

We can clean this up with Caffeinate. Here's how we'd do it.

### Create a Campaign

```ruby 
Caffeinate::Campaign.create!(name: "Onboarding Campaign", slug: "onboarding") 
```

### Create a Caffeinate::Dripper

Place the contents below in `app/drippers/onboarding_dripper.rb`:

```ruby 
class OnboardingDripper < ApplicationDripper
  drip :welcome_to_my_cool_app, delay: 0.hours
  drip :some_cool_tips, delay: 2.days
  drip :help_getting_started, delay: 3.days do 
    if mailing.user.company.present?
      mailing.unsubscribe!
      return false
    end
  end
end 
```

### Add a subscriber to the Campaign

```ruby 
class User < ApplicationRecord
  after_create_commit do 
    Caffeinate::Campaign.find_by(slug: "onboarding").subscribe(self)
  end 
end
```

### Run the Dripper

You'd normally want to do this in a cron/whenever/scheduled Sidekiq/etc job.

```ruby
OnboardingDripper.perform!
```

### Spend more time building

Now you can spend more time building your app and less time managing your marketing campaigns.
* Centralized logic makes it easy to understand the flow
* Subscription management, timings, send history all built-in
* Built on the stack you're already familiar with

There's a lot more than what you just saw, too! Caffeinate almost makes managing timed email sequences fun. 

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

## Documentation

* [Getting started, tips and tricks](https://github.com/joshmn/caffeinate/blob/master/docs/README.md) 
* [Better-than-average code documentation](https://rubydoc.info/github/joshmn/caffeinate)

## Upcoming features/todo

* Ability to optionally use relative start time when creating a step 
* Logo
* Conversion tracking
* Custom field support on CampaignSubscription
* GUI (?)
* REST API (?)

## Contributing

Just do it.

## Contributors & thanks

* Thanks to [sourdoughdev](https://github.com/sourdoughdev/caffeinate) for releasing the gem name to me. :) 
 
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
