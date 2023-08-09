module AhoyCaptain
  module Stats
    class ComparableContainerComponent < ViewComponent::Base
      def initialize(url, label, value, formatter = nil, selected = false)
        @url = url
        @label = label
        @value = value
        @formatter = formatter
        @selected = selected
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
        diff = @value.current - @value.compared_to
        (@value.current / diff).round(2) * 100
      end
    end
  end
end
