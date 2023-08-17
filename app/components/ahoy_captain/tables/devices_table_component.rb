module AhoyCaptain
  module Tables
    class DevicesTableComponent < DynamicTable
      register do
        progress_bar :display_name, value: :count, max: :total_count, title: "Device"
        number :count, title: "Visitors"
      end

    end
  end
end
