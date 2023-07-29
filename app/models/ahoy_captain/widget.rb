module AhoyCaptain
  class Widget
    class WidgetDisabled < StandardError
      attr_reader :frame
      def initialize(msg, frame = nil)
        @frame = frame
        super(msg)
      end
    end

    def self.disabled?(*names)
      AhoyCaptain.config.disabled_widgets.include?(names.join("."))
    end
  end
end
