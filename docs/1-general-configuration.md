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

Now that you've configured Caffeinate, it's time to [create your first CampaignMailer](2-campaign-mailer-customization.md).
