module AhoyCaptain
  class DeviceDecorator < ApplicationDecorator
    def self.csv_map(params = {})
      {
        "#{params[:devices_type]}" => :label,
        "Total" => :unit_amount
      }
    end

    def display_name
      search = search_query("#{params[:devices_type]}_eq" => label)
      frame_link(label, search)
    end

    def label
      object.label
    end

    def unit_amount
      object.count
    end

    def total_count
      object.total_count
    end
  end
end
