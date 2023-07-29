module AhoyCaptain
  class CitiesController < ApplicationController
    include AhoyCaptain::Limitable

    before_action do
      if Widget.disabled?(:locations, :cities)
        raise Widget::WidgetDisabled.new("Widget disabled", :geography)
      end
    end

    def index
      @cities = cached(:cities) do
        visit_query.within_range
          .select("city, country, count(concat(city, region, country)) as count, sum(count(concat(city, region, country))) over() as total_count")
          .group("city, region, country")
          .order(Arel.sql "count(concat(city, region, country)) desc")
          .limit(limit)
      end.map { |city| CityDecorator.new(city) }

      render json: @cities
    end
  end
end
