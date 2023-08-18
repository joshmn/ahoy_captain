module AhoyCaptain
  module Locations
    class MapsController < ApplicationController
      before_action do
        if Widget.disabled?(:locations, :map)
          raise Widget::WidgetDisabled.new("Widget disabled", :geography)
        end
      end

      def show
        @visits = visit_query.group("country").count
      end
    end
  end
end
