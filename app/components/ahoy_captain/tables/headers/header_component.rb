module AhoyCaptain
  module Tables
    module Headers
      class HeaderComponent < ViewComponent::Base
        def initialize(category_name:, unit_name:)
          @category_name = category_name
          @unit_name = unit_name
        end

        def fixed_height?
          true
        end
      end
    end
  end
end
