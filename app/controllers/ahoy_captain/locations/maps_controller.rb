module AhoyCaptain
  module Locations
    class MapsController < ApplicationController
      include Limitable

      before_action do
        if Widget.disabled?(:locations, :map)
          raise Widget::WidgetDisabled.new("Widget disabled", :geography)
        end
      end

      def show
        if request.variant.include?(:details)
          results = CountryQuery.call(params)
          results = results.limit(limit)
          @countries = paginate(results).map { |country| CountryDecorator.new(country, self) }
          render template: 'ahoy_captain/locations/countries/index'
        else
          @countries = visit_query.group("country").count
        end
      end
    end
  end
end
