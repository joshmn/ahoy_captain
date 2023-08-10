module AhoyCaptain
  module Stats
    class ComparableContainerComponent < ViewComponent::Base
      def initialize(url, label, comparable, formatter = nil, selected = false, compare = false)
        @url = url
        @label = label
        @comparable = comparable
        @formatter = formatter
        @selected = selected
        @compare = compare
      end

      def compare?
        @compare
      end

      def klass
        if percentage.negative?
          "text-red-400"
        else
          "text-green-400"
        end
      end

      # 〰 ↓ ↑
      def arrow
        if percentage.negative?
          "↓"
        elsif percentage.positive?
          "↑"
        else
          "〰"
        end
      end

      def percentage
        begin
          diff = value.current - value.compared_to
          if diff.zero?
            return 0
          end
          (value.current / diff).round(2) * 100
        rescue ZeroDivisionError
          0
        end
      end

      def number_to_duration(duration)
        if duration
          "#{duration.in_minutes.to_i}M #{duration.parts[:seconds].to_i}S"
        else
          "0M 0S"
        end
      end

      def compare_range_string
        range_to_string(@comparable.compare_range)
      end

      def range_string
        range_to_string(@comparable.range)
      end

      def value
        @comparable.result
      end

      def tooltip
        "#{formatted(value.current)} vs #{formatted(value.compared_to)} — #{number_to_percentage percentage} (#{arrow}) "
      end

      def formatted(value)
        public_send(@formatter, value)
      end

      private

      def range_to_string(range)
        [range[0], range[1]].map { |item| item.strftime('%m %B') }.join(' - ')
      end
    end
  end
end
