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
        first_visits = event_query.within_range.select("MIN(#{::AhoyCaptain.event.table_name}.id) as id").where(name: AhoyCaptain.config.view_name).group(:visit_id)
        event_query.within_range
                   .with_routes
                   .reselect("#{AhoyCaptain.config.event[:url_column]} as url, count(#{AhoyCaptain.config.event[:url_column]}) as total")
                   .distinct("(#{AhoyCaptain.config.event[:url_column]})")
                   .where(id: first_visits)
                   .group(Arel.sql("(#{AhoyCaptain.config.event[:url_column]})"))
                   .order(Arel.sql("count(#{AhoyCaptain.config.event[:url_column]}) desc"))
                   .limit(limit)
      end

      @pages = @pages.map { |page| PageDecorator.new(page) }
    end
  end
end
