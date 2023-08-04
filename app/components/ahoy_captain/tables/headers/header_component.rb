module AhoyCaptain
  module Tables
    module Headers
      class HeaderComponent < ViewComponent::Base
        def initialize(category_name:, unit_name:)
          @category_name = category_name
          @unit_name = unit_name
        end
      end
    end
  end
end
