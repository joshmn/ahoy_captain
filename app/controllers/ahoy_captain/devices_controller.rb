module AhoyCaptain
  class DevicesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:devices, params[:devices_type])
        raise Widget::WidgetDisabled.new("Widget disabled", :devices)
      end
    end

    def index
      results = cached(:devices, params[:devices_type]) do
        DeviceQuery.call(params)
                   .limit(limit)
      end

      @devices = results.map { |device| DeviceDecorator.new(device, self) }
    end
  end
end
