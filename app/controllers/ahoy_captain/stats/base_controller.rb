module AhoyCaptain
  module Stats
    class BaseController < ApplicationController

      INTERVAL_PERIOD = {
        "realtime" => ["minute"],
        "day" => ["minute", "hour"],
        "7d" => ["hour", "day"],
        "month" => ["day", "week"],
        "all" => ["day", "week", "month"]
      }

      INTERVALS = ["minute", "hour", "day", "week", "month"]

      private

      helper_method :metric_type
      def metric_type(stats)
        if compare_mode?
          stats.current.values.first.try(:class) || stats.compared_to.values.first.try(:class)
        else
          stats.values.first.class
        end
      end

      helper_method :selected_interval
      def selected_interval
        if params[:interval].in?(INTERVALS)
          params[:interval]
        else
          default_interval_for_period
        end
      end

      def default_interval_for_period
        default_interval_for_date_range(range)
      end

      def default_interval_for_date_range(range)
        if range[1].nil?
          # assume we're in a realtime
          return INTERVAL_PERIOD["realtime"][0]
        end
        diff = (range[1] - range[0]).seconds.in_days
        if diff >= 31
          "month"
        elsif diff > 1
          "day"
        elsif diff == 1
          "hour"
        else
          "hour"
        end
      end

      helper_method :available_intervals
      def available_intervals
        if range
          return INTERVAL_PERIOD["realtime"] if range[1].nil?

          diff = (range[1] - range[0]).seconds.in_days

          if diff < 1
            INTERVAL_PERIOD["day"]
          elsif diff <= 7
            INTERVAL_PERIOD["7d"]
          elsif diff <= 31
            INTERVAL_PERIOD["month"]
          else
            INTERVAL_PERIOD["all"]
          end
        else
          INTERVAL_PERIOD["month"]
        end
      end

      def lazy_window(result, value = 0, base = nil)
        if result.is_a?(AhoyCaptain::LazyComparableQuery::LazyComparison)
          result.result.current = lazy_window(result.result.current, value, range)
          result.result.compared_to = lazy_window(result.result.compared_to, value, result.compare_range)
          return result.result
        end

        base ||= range
        window = window_for(selected_interval, result.keys[0].class, base.numeric)

        window.each do |item|
          if result.key?(item)
            next
          end

          result[item] ||= value
        end

        transform = interval_label_transformation(selected_interval)

        if transform
          result.transform_keys! { |key| key.strftime(transform) }
        end

        result
      end

      def interval_label_transformation(interval)
        return nil
        if interval == 'hour'
          return '%H:%M %p'
        end

        nil
      end

      # base should be a range
      def window_for(interval, type, base = nil)
        function = case type.to_s
                    when 'Date', 'NilClass'
                      ->(value) {
                        date = Time.at(value).utc
                        if interval == 'month'
                          date.change(day: 1)
                        elsif interval == 'week'
                          date.beginning_of_week
                        elsif interval == 'day'
                          date.beginning_of_day
                        elsif interval == 'hour'
                          date.beginning_of_hour
                        elsif interval == 'minute'
                          date.beginning_of_minute
                        else
                          abort
                        end.to_date
                      }
                    when 'DateTime'
                      ->(value) { Time.at(value).utc.change(sec: 0) }
                   when 'ActiveSupport::TimeWithZone'
                     ->(value) { Time.at(value).utc }
                   else
                        raise ArgumentError
                    end

        base
             .step(1.send(interval))
             .to_a
             .map { |value| function.call(value) }
      end
    end
  end
end
