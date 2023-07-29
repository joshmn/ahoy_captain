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
        event_query.within_range.select("#{::Ahoy::Event.captain_url_signature} as url, count(*) as total")
                                .group(Arel.sql ("(#{::Ahoy::Event.captain_url_signature})"))
                                .order(Arel.sql("count(#{::Ahoy::Event.captain_url_signature}) desc"))
                                .limit(limit)
      end

      @pages = @pages.map { |page| PageDecorator.new(page) }

      render json: @pages
    end
  end
end
