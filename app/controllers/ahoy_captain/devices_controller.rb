module AhoyCaptain
  class DevicesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:devices, params[:type])
        raise Widget::WidgetDisabled.new("Widget disabled", :devices)
      end
    end

    def index
      @devices = cached(:devices, params[:type]) do
          visit_query
          .within_range
          .select("#{params[:type]} as label", "count(#{params[:type]}) as count", "sum(count(#{params[:type]})) over() as total_count")
          .group(params[:type])
          .order("count(#{params[:type]}) desc")
          .limit(limit)
      end.map { |device| DeviceDecorator.new(device) }
    end
  end
end
