module AhoyCaptain
  class RegionsController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:locations, :regions)
        raise Widget::WidgetDisabled.new("Widget disabled", :geography)
      end
    end

    def index
      results = cached(:regions) do
        RegionQuery.call(params)
                   .limit(limit)
      end

      @regions = paginate(results).map { |region| RegionDecorator.new(region, self) }
    end
  end
end
