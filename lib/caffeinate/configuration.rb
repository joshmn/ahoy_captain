module Caffeinate
  class Configuration
    attr_accessor :now, :async_delivery, :mailing_job

    def initialize
      @now = -> { Time.current }
      @async_delivery = false
      @mailing_job = nil
    end

    def now=(val)
      raise ArgumentError, "#now must be a proc" unless val.respond_to?(:call)

      super
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
