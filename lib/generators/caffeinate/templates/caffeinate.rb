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
  #   config.mailing_job = nil
  #
  # config.async_delivery = true
  # config.mailing_job = 'MyCustomCaffeinateJob'
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
end
