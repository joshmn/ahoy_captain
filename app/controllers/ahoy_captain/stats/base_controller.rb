module AhoyCaptain
  module Stats
    class BaseController < ApplicationController
      include Rangeable

      INTERVAL_PERIOD = {
        "realtime" => ["minute"],
        "day" => ["minute", "hour"],
        "7d" => ["hour", "day"],
        "month" => ["day", "week"],
        "all" => ["day", "week", "month"]
      }

      INTERVALS = ["minute", "hour", "day", "week", "month"]
      private

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
        diff = (range[1] - range[0]).seconds.in_days.to_i
        if diff > 30
          "month"
        elsif diff > 0
          "day"
        else
          "hour"
        end
      end

      helper_method :available_intervals
      def available_intervals
        if range
          return INTERVAL_PERIOD["realtime"] if range[1].nil?

          diff = (range[1] - range[0]).seconds.in_days

          if diff == 0
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
    end
  end
end
