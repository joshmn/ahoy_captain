module AhoyCaptain
  class CountriesController < ApplicationController
    include Limitable
    include Rangeable

    before_action do
      if Widget.disabled?(:locations, :countries)
        raise Widget::WidgetDisabled.new("Widget disabled", :geography)
      end
    end

    def index
      @countries = cached(:countries) do
        visit_query
          .within_range
          .reselect("country as label, count(country) as count, sum(count(country)) OVER() as total_count")
          .group("country")
          .order("count(country) desc")
          .limit(limit)
      end.map { |country| CountryDecorator.new(country) }
    end
  end

end
