module AhoyCaptain
  module Tables
    class HeaderComponent < ViewComponent::Base
      def initialize(headers, options = {})
        @headers = headers.flatten
        @options = options
      end

      def fixed_height?
        if @options.key?(:fixed_height)
          @options[:fixed_height]
        else
          true
        end
      end
    end
  end
end
