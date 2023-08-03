module AhoyCaptain
  class EntryPagesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:entry_pages)
        raise Widget::WidgetDisabled.new("Widget disabled", :pages)
      end
    end

    def index
      results = cached(:entry_pages) do
        EntryPagesQuery.call(params, event_query)
                      .order(Arel.sql "count(#{AhoyCaptain.config.event[:url_column]}) desc")
                      .limit(limit)
      end

      @pages = paginate(results).map { |page| EntryPageDecorator.new(page, self) }
    end
  end
end
