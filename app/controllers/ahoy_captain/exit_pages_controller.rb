module AhoyCaptain
  class ExitPagesController < ApplicationController
    include Limitable

    before_action do
      if Widget.disabled?(:exit_pages)
        raise Widget::WidgetDisabled.new("Widget disabled", :pages)
      end
    end

    def index
      @pages = cached(:exit_pages) do
        ExitPagesQuery.call(params, event_query)
                      .order(Arel.sql "count(#{AhoyCaptain.config.event[:url_column]}) desc")
                              .limit(limit)
      end
      @pages = @pages.map { |page| PageDecorator.new(page) }
    end
  end
end
