module AhoyCaptain
  class EntryPagesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:entry_pages)
        raise Widget::WidgetDisabled.new("Widget disabled", :pages)
      end
    end

    def index
      @pages = cached(:entry_pages) do
        EntryPagesQuery.call(params, event_query)
                      .order(Arel.sql "count(#{AhoyCaptain.config.event[:url_column]}) desc")
                      .limit(limit)
      end

      @pages = @pages.map { |page| EntryPageDecorator.new(page) }
    end
  end
end
