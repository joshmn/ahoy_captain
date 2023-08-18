module AhoyCaptain
  module Locations
    class CitiesController < ApplicationController
      include AhoyCaptain::Limitable

      before_action do
        if Widget.disabled?(:locations, :cities)
          raise Widget::WidgetDisabled.new("Widget disabled", :geography)
        end
      end

      def index
        results = cached(:cities) do
          CityQuery.call(params)
                   .limit(limit)
        end

        @cities = paginate(results).map { |city| CityDecorator.new(city, self) }
      end
    end
  end
end
