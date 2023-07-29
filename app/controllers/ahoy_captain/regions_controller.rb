module AhoyCaptain
  class RegionsController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:locations, :regions)
        raise Widget::WidgetDisabled.new("Widget disabled", :geography)
      end
    end

    def index
      @regions = cached(:regions) do
        visit_query.within_range
          .reselect("region, country, count(concat(region, country)) as count, sum(count(region)) over() as total_count")
          .group("region, country")
          .order(Arel.sql "count(concat(region, country)) desc")
          .limit(limit)
      end.map { |region| RegionDecorator.new(region) }
    end
  end
end
