module AhoyCaptain
  class DeviceQuery < ApplicationQuery
    def build
      visit_query
        .select("#{params[:devices_type]} as label", "count(#{params[:devices_type]}) as count", "sum(count(#{params[:devices_type]})) over() as total_count")
        .group(params[:devices_type])
        .order("count(#{params[:devices_type]}) desc")
    end
  end
end
