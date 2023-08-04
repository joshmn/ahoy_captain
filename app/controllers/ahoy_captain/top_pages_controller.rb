module AhoyCaptain
  class TopPagesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:top_pages)
        raise Widget::WidgetDisabled.new("Widget disabled", :pages)
      end
    end

    def index
      results = cached(:top_pages) do
        TopPageQuery.call(params)
                   .limit(limit)
      end

      @pages = paginate(results).map { |page| TopPageDecorator.new(page, self) }
    end
  end
end
