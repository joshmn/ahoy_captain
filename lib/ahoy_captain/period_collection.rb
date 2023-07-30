module AhoyCaptain
  class PeriodCollection
    class Period
      attr_reader :param, :label, :range
      def initialize(param:, label:, range:)
        @param = param
        @label = label
        @range = range
      end
    end

    def self.load_default
      instance = new
      {
        realtime: {
          label: "Realtime",
          range: -> { [3.minute.ago, Time.current] },
        },
        day: {
          label: "Day",
          range: -> { [Time.current.beginning_of_day, Time.current] },
        },
        '7d': {
          label: "7 Days",
          range: -> {  [7.days.ago, Time.current] },
        },
        '30d': {
          label: "30 Days",
          range: -> { [30.days.ago, Time.current] },
        },
        mtd: {
          label: "Month-to-date",
          range: -> { [Time.current.beginning_of_month, Time.current] },
        },
        lastmonth: {
          label: "Last month",
          range: -> { [1.month.ago.beginning_of_month, 1.month.ago.end_of_month] },
        },
        ytd: {
          label: "This year",
          range: -> { [Time.current.beginning_of_year, Time.current] },
        },
        '12mo': {
          label: "12 months",
          range: -> { [12.months.ago.to_datetime, Time.current] },
        },
        all: {
          label: "All-time",
          range: -> { [Date.new(2004, 8, 1).to_datetime, Time.current] },
        },
      }.each do |param, options|
        instance.add(param, options[:label], options[:range])
      end
      instance.default = :mtd
      instance
    end

    attr_reader :default, :max
    def initialize
      @periods = {}
      @default = nil
      @max = nil
    end

    def add(param, label, range_proc)
      raise ArgumentError, "range must be a proc, or respond to .call" unless range_proc.respond_to?(:call)
      raise ArgumentError, "range.call must return a range or an array" unless range_proc.call.is_a?(Range) || range_proc.call.is_a?(Array)

      @periods[param.to_sym] = Period.new(param: param, label: label, range: range_proc)
    end

    def delete(param)
      @periods.delete(param.to_sym)
    end

    def reset
      @periods = {}
      @default = nil
    end

    def each(&block)
      @periods.each(&block)
    end

    def find(value)
      @periods[value.try(:to_sym)]
    end

    def all
      @periods
    end

    def default=(val)
      @default = val.to_sym
    end

    def max=(amount)
      @max = amount
    end

    def for(value)
      if value.nil?
        period = @periods[@default]
      else
        period = (@periods[value.to_sym] || @periods[@default])
      end

      if period
        period.range.call
      else
        nil
      end
    end
  end
end
