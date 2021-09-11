<div align="center">
  <img width="450" src="https://github.com/joshmn/caffeinate/raw/master/logo.png" alt="Caffeinate logo" />
</div>

<div align="center">
    <a href="https://codecov.io/gh/joshmn/caffeinate">
        <img src="https://codecov.io/gh/joshmn/caffeinate/branch/master/graph/badge.svg?token=5LCOB4ESHL" alt="Coverage"/>
    </a>
    <a href="https://codeclimate.com/github/joshmn/caffeinate/maintainability">
        <img src="https://api.codeclimate.com/v1/badges/9c075416ce74985d5c6c/maintainability" alt="Maintainability"/>
    </a>
     <a href="https://inch-ci.org/github/joshmn/caffeinate">
        <img src="https://inch-ci.org/github/joshmn/caffeinate.svg?branch=master" alt="Docs"/>
    </a>
</div>

# Caffeinate

Caffeinate is a drip email engine for managing, creating, and sending scheduled email sequences from your Ruby on Rails application.

Caffeinate provides a simple DSL to create scheduled email sequences which can be used by ActionMailer without any additional configuration. 

There's a cool demo with all the things included at [caffeinate.email](https://caffeinate.email). You can view the [marketing site source code here](https://github.com/joshmn/caffeinate-marketing).

## Is this thing dead?

No! Not at all!

There's not a lot of activity here because it's stable and working! I am more than happy to entertain new features.

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
  def welcome_to_my_cool_app(user)
    mail(to: user.email, subject: "Welcome to CoolApp!")
  end

  def some_cool_tips(user)
    return if user.unsubscribed_from_onboarding_campaign?

    mail(to: user.email, subject: "Here are some cool tips for MyCoolApp")
  end

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
* It's going to be _so fun_ to scale when you finally want to add more unsubscribe links for different types of sequences
    - "one of your projects has expired", but which one? Then you have to add a column to `projects` and manage all that state... ew

## Do this all better in five minutes

In five minutes you can implement this onboarding campaign:

### Install it

Add to Gemfile, run the installer, migrate:

```bash
$ bundle add caffeinate
$ rails g caffeinate:install
$ rake db:migrate
```

### Clean up the mailer logic

Mailers should be responsible for receiving context and creating a `mail` object. Nothing more.

The only other change you need to make is the argument that the mailer action receives. It will now receive a `Caffeinate::Mailing`. [Learn more about the data models](docs/2-data-models.md):

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

### Create a Dripper

A Dripper has all the logic for your sequence and coordinates with ActionMailer on what to send.

In `app/drippers/onboarding_dripper.rb`:

```ruby
class OnboardingDripper < ApplicationDripper
  # each sequence is a campaign. This will dynamically create one by the given slug
  self.campaign = :onboarding 
  
  # gets called before every time we process a drip
  before_drip do |_drip, mailing| 
    if mailing.subscription.subscriber.onboarding_completed?
      mailing.subscription.unsubscribe!("Completed onboarding")
      throw(:abort)
    end 
  end
  
  # map drips to the mailer
  drip :welcome_to_my_cool_app, mailer: 'OnboardingMailer', delay: 0.hours
  drip :some_cool_tips, mailer: 'OnboardingMailer', delay: 2.days
  drip :help_getting_started, mailer: 'OnboardingMailer', delay: 3.days
end
```

We want to skip sending the `mailing` if the `subscriber` (`User`) completed onboarding. Let's unsubscribe 
with `#unsubscribe!` and give it an optional reason of `Completed onboarding` so we can reference it later 
when we look at analytics. `throw(:abort)` halts the callback chain just like regular Rails callbacks, stopping the 
mailing from being sent.

### Add a subscriber to the Campaign

Call `OnboardingDripper.subscribe` to subscribe a polymorphic `subscriber` to the Campaign, which creates
a `Caffeinate::CampaignSubscription`.

```ruby
class User < ApplicationRecord
  after_commit on: :create do
    OnboardingDripper.subscribe!(self)
  end
end
```

### Run the Dripper

```ruby
OnboardingDripper.perform!
```

### Done

You're done. 

[Check out the docs](/docs/README.md) for a more in-depth guide that includes all the options you can use for more complex setups,
tips, tricks, and shortcuts.

## But wait, there's more

Caffeinate also...

* ✅ Allows hyper-precise scheduled times. 9:19AM _in the user's timezone_? Sure! **Only on business days**? YES! 
* ✅ Periodicals
* ✅ Manages unsubscribes
* ✅ Works with singular and multiple associations
* ✅ Compatible with every background processor
* ✅ Tested against large databases at AngelList and is performant as hell
* ✅ Effortlessly handles complex workflows
    - Need to skip a certain mailing? You can!
 
## Documentation

* [Getting started, tips and tricks](https://github.com/joshmn/caffeinate/blob/master/docs/README.md)
* [Better-than-average code documentation](https://rubydoc.info/gems/caffeinate)

## Upcoming features/todo

[Handy dandy roadmap](https://github.com/joshmn/caffeinate/projects/1).

## Alternatives

Not a fan of Caffeinate? I built it because I wasn't a fan of the alternatives. To each their own:

* https://github.com/honeybadger-io/heya
* https://github.com/tarr11/dripper
* https://github.com/Sology/maily_herald

## Contributing

There's so much more that can be done with this. I'd love to see what you're thinking.

If you have general feedback, I'd love to know what you're using Caffeinate for! Please email me (any-thing [at] josh.mn) or [tweet me @joshmn](https://twitter.com/joshmn) or create an issue! I'd love to chat.

## Contributors & thanks

* Thanks to [sourdoughdev](https://github.com/sourdoughdev/caffeinate) for releasing the gem name to me. :)
* Thanks to [markokajzer](https://github.com/markokajzer) for listening to me talk about this most mornings.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
