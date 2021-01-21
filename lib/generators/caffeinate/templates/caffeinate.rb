# frozen_string_literal: true

Caffeinate.setup do |config|
  # == Current time
  #
  # Used for when we set a datetime column to "now" in the database
  #
  # Default:
  #   config.now = -> { Time.current }
  #
  # config.now = -> { DateTime.now }
  #
  # == Mailer delivery
  #
  # If you want to handle delivery of individual mails in the background. See lib/caffeinate/deliver_async.rb for
  # implementation details
  #
  # Default:
  #   config.async_delivery = false
  #   config.async_delivery_class = nil
  #
  # config.async_delivery = true
  # config.async_delivery_class = 'MyCustomCaffeinateJob'
  #
  # == Batching
  #
  # When a Dripper is performed and sends the mails, we use `find_in_batches`. Use `batch_size` to set the batch size.
  # You can set this on a dripper as well for more granular control.
  #
  # Default:
  #   config.batch_size = 1_000
  #
  # config.batch_size = 100
  #
  # == Implicit Campaigns
  #
  # Instead of manually having to create a Campaign, you can let Caffeinate do a `find_or_create_by` at runtime.
  # This is probably dangerous but it hasn't burned me yet so here you go:
  #
  # Default:
  #   config.implicit_campaigns = true
  #
  # config.implicit_campaigns = false
  #
  # == Default reasons
  #
  # The default unsubscribe and end reasons.
  #
  # Default:
  #   config.default_unsubscribe_reason = nil
  #   config.default_ended_reason = nil
  #
  # config.default_unsubscribe_reason = "User unsubscribed"
  # config.default_ended_reason = "User ended"
end
