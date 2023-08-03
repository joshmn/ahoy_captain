module AhoyCaptain
  class CitiesController < ApplicationController
    include AhoyCaptain::Limitable

    before_action do
      if Widget.disabled?(:locations, :cities)
        raise Widget::WidgetDisabled.new("Widget disabled", :geography)
      end
    end

    def index
      results = cached(:cities) do
        visit_query
          .select("city, country, count(concat(city, region, country)) as count, sum(count(concat(city, region, country))) over() as total_count")
          .where.not(city: nil)
          .group("city, region, country")
          .order(Arel.sql "count(concat(city, region, country)) desc")
          .limit(limit)
      end

      @cities = paginate(results).map { |city| CityDecorator.new(city, self) }
    end
  end
end
