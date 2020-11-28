---
redirect_from: /docs/10-best-practices.html
---

# Best Practices

There are some things we've picked up implementing Caffeinate that we thought we could share with you and your beautiful
application.

## Separate ActionMailer class

Having a separate base class was common.
 
```ruby 
class CaffeinateMailer < ApplicationMailer; end 
```

```ruby 
class OnboardingMailer < CaffeinateMailer; end
```

## Separate mailer layout 

This too. Removes a conditional check for the unsubscribe link.

```ruby 
class CaffeinateMailer < ApplicationMailer
  layout 'caffeinate'
end
```

## Adapter for API actions

In the case that you wanted to move away from Caffeinate at some point, subbing out API calls is easier than a find/replace.

```ruby 
module Marketing
  class Manager
    class << self 
      def subscribe_to_campaign(campaign_slug:, subscriber:, user: nil, **args)
        ::Caffeinate::Campaign[campaign].subscribe(subscriber, user: user)
      end
    end 
  end 
end
```
