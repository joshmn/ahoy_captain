# frozen_string_literal: true

module Caffeinate
  # Global configuration
  class Configuration

    # Used for relation to a lot of things. If you have a weird time setup, set this.
    # Accepts anything that responds to `#call`; you'll probably use a block.
    attr_accessor :now

    # If true, enqueues the processing of a `Caffeinate::Mailing` to the background worker class
    # as defined in `async_delivery_class`
    #
    # Default is false
    attr_accessor :async_delivery

    # The background worker class for `async_delivery`.
    attr_accessor :async_delivery_class

    # If true, uses `deliver_later` instead of `deliver`
    attr_accessor :deliver_later

    # The number of `Caffeinate::Mailing` records we find in a batch at once.
    attr_accessor :batch_size

    # The path to the drippers
    attr_accessor :drippers_path

    # Automatically creates a `Caffeinate::Campaign` record by the named slug of the campaign from a dripper
    # if none is found by the slug.
    attr_accessor :implicit_campaigns

    # The default reason for an ended `Caffeinate::CampaignSubscription`
    attr_accessor :default_ended_reason

    # The default reason for an unsubscribed `Caffeinate::CampaignSubscription`
    attr_accessor :default_unsubscribe_reason

    def initialize
      @now = -> { Time.current }
      @async_delivery = false
      @deliver_later = false
      @async_delivery_class = nil
      @batch_size = 1_000
      @drippers_path = 'app/drippers'
      @implicit_campaigns = true
      @default_ended_reason = nil
      @default_unsubscribe_reason = nil
    end

    def now=(val)
      raise ArgumentError, '#now must be a proc' unless val.respond_to?(:call)

      @now = val
    end

    def implicit_campaigns?
      @implicit_campaigns
    end

    def time_now
      @now.call
    end

    def async_delivery?
      @async_delivery
    end

    def deliver_later?
      @deliver_later
    end

    def async_delivery_class
      @async_delivery_class.constantize
    end
  end
end
