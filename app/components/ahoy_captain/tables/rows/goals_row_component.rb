module AhoyCaptain
  module Tables
    module Rows
      class GoalsRowComponent < RowComponent

        def total
          @item.total_count
        end
      end
    end
  end
end
