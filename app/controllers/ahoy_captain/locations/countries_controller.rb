module AhoyCaptain
  module Locations
    class CountriesController < ApplicationController
      include Limitable

      before_action do
        if Widget.disabled?(:locations, :countries)
          raise Widget::WidgetDisabled.new("Widget disabled", :geography)
        end
      end

      def index
        results = cached(:countries) do
          CountryQuery.call(params)
                      .limit(limit)
        end

        @countries = paginate(results).map { |country| CountryDecorator.new(country, self) }
      end
    end
  end
end
