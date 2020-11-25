module Caffeinate
  class Configuration
    attr_accessor :now

    def initialize
      @now = -> { Time.current }
    end

    def now=(val)
      raise ArgumentError, "#now must be a proc" unless val.respond_to?(:call)

      super
    end

    def time_now
      @now.call
    end
  end
end
