module AhoyCaptain
  module Stats
    class ContainerComponent < ViewComponent::Base
      def initialize(url, label, value, formatter, selected = false)
        @url = url
        @label = label
        @value = value
        @formatter = formatter
        @selected = selected
      end

      def formatted(value)
        public_send(@formatter, value)
      end


      def number_to_duration(duration)
        if duration
          "#{duration.in_minutes.to_i}M #{duration.parts[:seconds].to_i}S"
        else
          "0M 0S"
        end
      end
    end
  end
end
