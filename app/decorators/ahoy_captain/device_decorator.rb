module AhoyCaptain
  class DeviceDecorator < ApplicationDecorator
    def display_name
      search = search_query("#{params[:devices_type]}_eq" => object.label)
      frame_link(object.label, search)
    end

    def unit_amount
      object.count
    end

    def total_count
      object.total_count
    end
  end
end
