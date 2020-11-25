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

    def time_now
      @now.call
    end

    def async_delivery?
      @async_delivery
    end

    def mailing_job_class
      @mailing_job.constantize
    end
  end
end
