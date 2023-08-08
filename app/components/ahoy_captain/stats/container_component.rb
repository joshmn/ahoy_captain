module AhoyCaptain
  module Stats
    class ContainerComponent < ViewComponent::Base
      def initialize(url, label, value, selected = false)
        @url = url
        @label = label
        @value = value
        @selected = selected
      end
    end
  end
end
