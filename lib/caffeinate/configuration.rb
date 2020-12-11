# frozen_string_literal: true

module Caffeinate
  # Global configuration
  class Configuration
    attr_accessor :now, :async_delivery, :mailing_job, :batch_size, :drippers_path, :implicit_campaigns

    def initialize
      @now = -> { Time.current }
      @async_delivery = false
      @mailing_job = nil
      @batch_size = 1_000
      @drippers_path = 'app/drippers'
      @implicit_campaigns = true
    end

    def now=(val)
      raise ArgumentError, '#now must be a proc' unless val.respond_to?(:call)

      @now = val
    end

    # Automatically create a `::Caffeinate::Campaign` object if not found per `Dripper.inferred_campaign_slug`
    def implicit_campaigns?
      @implicit_campaigns == true
    end

    # The current time, for database calls
    def time_now
      @now.call
    end

    # If delivery is asyncronous
    def async_delivery?
      @async_delivery
    end

    # The @mailing_job constantized. Only used if `async_delivery = true`
    def mailing_job_class
      @mailing_job.constantize
    end
  end
end
