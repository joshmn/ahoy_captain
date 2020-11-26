---
redirect_from: /docs/1-general-configuration.html
---

# General Configuration

You can configure Caffeinate settings in `config/initializers/caffeinate.rb`.

## `now`

Caffeinate handles timestamps by using `Time.current` by default. You may change this
in the initializer:

```ruby
config.now = -> { DateTime.now }
```

`config.now` must respond to `#call`; using a Proc or Lambda works here. 

Now that you've configured Caffeinate, it's time to [create your first Dripper](2-campaign-mailer-customization.md).

## `async_delivery`

By default, a Mailer is delivered in the current thread. You can queue it up to happen in the background if you'd like.

```ruby
config.async_delivery = true 
config.mailing_job = 'MyJob' 
```

Assume you have `MyJob` defined in `app/jobs`. This job simply needs to implement `perform_later` or `perform_async` and 
inherit `Caffeinate::DeliverAsync` like so:

```ruby
class MyJob < ApplicationJob
  include Caffeinate::DeliveryAsync
end 
```

Or using Sidekiq:

```ruby
class MyJob
  include Sidekiq::Worker
  include Caffeinate::DeliveryAsync
end 
```

And you're done.
