module AhoyCaptain
  class DeviceDecorator < ApplicationDecorator
    def display_name
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
