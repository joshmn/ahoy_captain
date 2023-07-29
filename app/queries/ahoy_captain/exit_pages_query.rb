module AhoyCaptain
  class ExitPagesQuery < ApplicationQuery

    def build
      max_id_query = @query.with_routes.select("max(#{AhoyCaptain.event.table_name}.id) as id").group("visit_id")
      @query = @query.with_routes.select(
        "#{AhoyCaptain.config.event[:url_column]} as url",
        "count(#{AhoyCaptain.config.event[:url_column]}) as count",
        "sum(count(#{AhoyCaptain.config.event[:url_column]})) over() as total_count"
      )
                     .where(id: max_id_query)
                     .group(AhoyCaptain.config.event[:url_column])
    end


  end
end
