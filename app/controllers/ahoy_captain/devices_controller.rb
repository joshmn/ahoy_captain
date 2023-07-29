module AhoyCaptain
  class DevicesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:devices, params[:devices_type])
        raise Widget::WidgetDisabled.new("Widget disabled", :devices)
      end
    end

    def index
      @devices = cached(:devices, params[:devices_type]) do
          visit_query
          .select("#{params[:devices_type]} as label", "count(#{params[:devices_type]}) as count", "sum(count(#{params[:devices_type]})) over() as total_count")
          .group(params[:devices_type])
          .order("count(#{params[:devices_type]}) desc")
          .limit(limit)
      end.map { |device| DeviceDecorator.new(device) }
    end
  end
end
