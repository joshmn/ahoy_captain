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
        last_visits = event_query.within_range.select("MAX(#{::Ahoy::Event.table_name}.id) as id").where(name: AhoyCaptain.config.view_name).group(:visit_id)
        event_query.within_range.with_routes
                                .reselect("#{::Ahoy::Event.captain_url_signature} as url, count(#{::Ahoy::Event.captain_url_signature}) as total")
                                .distinct("(#{::Ahoy::Event.captain_url_signature})")
                                .where(id: last_visits)
                                .group(Arel.sql ("(#{::Ahoy::Event.captain_url_signature})"))
                                .order(Arel.sql("count(#{::Ahoy::Event.captain_url_signature}) desc"))
                                .limit(limit)
      end

      @pages = @pages.map { |page| PageDecorator.new(page) }
    end
  end
end
