# frozen_string_literal: true

Caffeinate.setup do |config|
  # == Current time
  #
  # Used for when we set a datetime column to "now" in the database
  #
  # Default:
  #   -> { Time.current }
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
end
