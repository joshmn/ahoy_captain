module AhoyCaptain
  class EntryPagesQuery < ApplicationQuery

    def build
      max_id_query = event_query.with_routes.select("min(#{AhoyCaptain.event.table_name}.created_at) as created_at").group("visit_id")
      event_query.with_routes.select(
        "#{AhoyCaptain.config.event[:url_column]} as url",
        "count(#{AhoyCaptain.config.event[:url_column]}) as count",
        "sum(count(#{AhoyCaptain.config.event[:url_column]})) over() as total_count"
      )
                     .where(id: max_id_query)
                     .group(AhoyCaptain.config.event[:url_column])
                     .order(Arel.sql "count(#{AhoyCaptain.config.event[:url_column]}) desc")
    end


  end
end
