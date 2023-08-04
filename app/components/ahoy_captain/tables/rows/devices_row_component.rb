module AhoyCaptain
  module Tables
    module Rows
      class DevicesRowComponent < RowComponent

        def total
          @item.total_count
        end
      end
    end
  end
end
