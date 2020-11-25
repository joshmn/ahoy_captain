---
redirect_from: /docs/0-installation.html
---

# Installation

Caffeinate is a Ruby Gem meant to be used with the Ruby on Rails framework.

```ruby
gem 'caffeinate'
```

It's a [Rails Engine](http://guides.rubyonrails.org/engines.html) that can be injected 
into your existing Ruby on Rails application.

## Setting up Caffeinate

After installing the gem, you need to run the install generator. 

```bash 
$ rails g caffeinate:install  
``` 

The generator adds these core files:

* `app/campaign_mailers/application_campaign.rb`
* `config/initializers/caffeinate.rb`

Now, migrate your database before starting the server:

```bash
$ rails db:migrate
```

Next, [configure Caffeinate](1-general-configuration.md).
