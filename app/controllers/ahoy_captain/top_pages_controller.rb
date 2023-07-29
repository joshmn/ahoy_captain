module AhoyCaptain
  class TopPagesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:top_pages)
        raise Widget::WidgetDisabled.new("Widget disabled", :pages)
      end
    end

    def index
      @pages = cached(:top_pages) do
        event_query.within_range.with_routes.select(
          "#{AhoyCaptain.config.event[:url_column]} as url",
          "count(*) as count",
          "sum(count(*)) over() as total_count"
        )
                                .group(Arel.sql ("(#{AhoyCaptain.config.event[:url_column]})"))
                                .order(Arel.sql("count(#{AhoyCaptain.config.event[:url_column]}) desc"))
                                .limit(limit)
      end

      @pages = @pages.map { |page| TopPageDecorator.new(page) }
    end
  end
end
