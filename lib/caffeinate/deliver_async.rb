module Caffeinate
  # Method for handling async delivery. `include` it for plug-and-play.
  #
  #   class MyWorker
  #     include Sidekiq::Worker
  #     include Caffeinate::AsyncMailing
  #   end
  #
  # To use this, make sure your initializer is configured correctly:
  #   config.async_delivery = true
  #   config.mailing_job = 'MyWorker'
  module DeliverAsync
    def perform(mailing_id)
      mailing = ::Caffeinate::Mailing.find(mailing_id)
      return unless mailing.pending?

      mailing.deliver!
    end
  end
end
