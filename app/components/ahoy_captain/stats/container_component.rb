module AhoyCaptain
  module Stats
    class ContainerComponent < ViewComponent::Base
      def initialize(url, label, value)
        @url = url
        @label = label
        @value = value
      end
    end
  end
end
