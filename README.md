# Caffeinate

Caffeinate is a drip campaign engine for Ruby on Rails applications.

Caffeinate tries to make creating and managing timed and scheduled email sequences fun. It works alongside ActionMailer 
and has everything you need to get started and to successfully manage campaigns. It's only dependency is the stack you're
already familiar with: Ruby on Rails.

There's a cool demo with all the things included at [www.caffeinate.email](https://caffeinate.email). You can view the [marketing 
site source code here](https://github.com/joshmn/caffeinate-marketing).

![Caffeinate logo](https://github.com/joshmn/caffeinate/raw/master/logo.png)

## Do you suffer from ActionMailer tragedies?

If you have _anything_ like this is your codebase, **you need Caffeinate**:

```ruby 
class User < ApplicationRecord
  after_commit on: :create do 
    OnboardingMailer.welcome_to_my_cool_app(self).deliver_later
    OnboardingMailer.some_cool_tips(self).deliver_later(wait: 2.days)
    OnboardingMailer.help_getting_started(self).deliver_later(wait: 3.days)
  end 
end 
```

```ruby 
class OnboardingMailer < ActionMailer::Base 
  # Send on account creation
  def welcome_to_my_cool_app(user)
    mail(to: user.email, subject: "Welcome to CoolApp!")
  end

  # Send 2 days after the user signs up
  def some_cool_tips(user)
    return if user.unsubscribed_from_onboarding_campaign?

    mail(to: user.email, subject: "Here are some cool tips for MyCoolApp")
  end 

  # Sends 3 days after the user signs up and hasn't added a company profile yet
  def help_getting_started(user)
    return if user.unsubscribed_from_onboarding_campaign?
    return if user.onboarding_completed?

    mail(to: user.email, subject: "Do you need help getting started?")
  end 
end 
```

### What's wrong with this?

* You're checking state in a mailer
* The unsubscribe feature is, most likely, tied to a `User`, which means...
* It's going to be _so fun_ to scale horizontally

## Caffeinate to the rescue

Caffeinate combines a simple scheduling DSL, ActionMailer, and your data models to create scheduled email sequences.

What can you do with drip campaigns? 
* Onboard new customers with cool tips and tricks
* Remind customers to use your product
* Nag customers about using your product
* Reach their spam folder after you fail to handle their unsubscribe request
* And more!

## Onboarding in Caffeinate

In five minutes you can implement this onboarding campaign, and it won't even hijack your entire app!

### Install it 

Add to Gemfile, run the installer, migrate:

```bash 
$ bundle add caffeinate
$ rails g caffeinate:install
$ rake db:migrate
```

### Remove that ActionMailer logic

Just delete it. Mailers should be responsible for receiving context and creating a `mail` object. Nothing more.

The only other change you need to make is the argument that the mailer action receives:

```ruby 
class OnboardingMailer < ActionMailer::Base 
  def welcome_to_my_cool_app(mailing)
    @user = mailing.subscriber 
    mail(to: @user.email, subject: "Welcome to CoolApp!")
  end

  def some_cool_tips(mailing)
    @user = mailing.subscriber
    mail(to: @user.email, subject: "Here are some cool tips for MyCoolApp")
  end 

  def help_getting_started(mailing)
    @user = mailing.subscriber
    mail(to: @user.email, subject: "Do you need help getting started?")
  end 
end 
```

While we're there, let's add an unsubscribe link to the views or layout: 

```erb
<%= link_to "Stop receiving onboarding tips :(", caffeinate_unsubscribe_url %>
```

### Create a Dripper

A Dripper has all the logic for your Campaign and coordinates with ActionMailer on what to send.

In `app/drippers/onboarding_dripper.rb`:

```ruby 
class OnboardingDripper < ApplicationDripper
  drip :welcome_to_my_cool_app, mailer: 'OnboardingMailer', delay: 0.hours
  drip :some_cool_tips, mailer: 'OnboardingMailer', delay: 2.days
  drip :help_getting_started, mailer: 'OnboardingMailer', delay: 3.days
end 
```

The `drip` syntax is `def drip(mailer_action, options = {})`.

### Add a subscriber to the Campaign

Call `OnboardingDripper.subscribe` to subscribe a polymorphic `subscriber` to the Campaign, which creates 
a `Caffeinate::CampaignSubscription`.

```ruby 
class User < ApplicationRecord
  after_commit on: :create do 
    OnboardingDripper.subscribe(self)
  end 

  after_commit on: :update do 
    if onboarding_completed? && onboarding_completed_changed?
      if OnboardingDripper.subscribed?(self)
        OnboardingDripper.unsubscribe(self)
      end 
    end
  end
end
```

When a `Caffeinate::CampaignSubscription` is created, the relevant Dripper is parsed and `Caffeinate::Mailing` records 
are created from the `drip` DSL. A `Caffeinate::Mailing` record has a `send_at` attribute which tells Caffeinate when we 
can send the mail, which we get from `Caffeiate::Mailing#mailer_class` and `Caffeinate::Mailing#mailer_action`.

### Run the Dripper

Running `OnboardingDripper.perform!` every `x` minutes will call `Caffeinate::Mailing#process!` on `Caffeinate::Mailing`
records that have `send_at < Time.now`. 

```ruby
OnboardingDripper.perform!
```

### Done. But wait, there's more fun if you want

* Automatic subscriptions
* Campaign-specific unsubscribe links 
* Reasons for unsubscribing so you can have some sort of analytics
* Periodical emails (daily, weekly, monthly digests, anyone?)
* Parameterized mailer support a la `OnboardingMailer.with(mailing: mailing)`

## Documentation

* [Getting started, tips and tricks](https://github.com/joshmn/caffeinate/blob/master/docs/README.md) 
* [Better-than-average code documentation](https://rubydoc.info/gems/caffeinate)

## Upcoming features/todo

[Handy dandy roadmap](https://github.com/joshmn/caffeinate/projects/1).

## Alternatives

Not a fan? There are some alternatives!

* https://github.com/honeybadger-io/heya
* https://github.com/tarr11/dripper
* https://github.com/Sology/maily_herald

## Contributing

Just do it.

## Contributors & thanks

* Thanks to [sourdoughdev](https://github.com/sourdoughdev/caffeinate) for releasing the gem name to me. :) 
 
## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
