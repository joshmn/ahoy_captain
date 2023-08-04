module AhoyCaptain
  class TopPageQuery < ApplicationQuery
    def build
      event_query.with_routes
                 .select(
        "#{AhoyCaptain.config.event[:url_column]} as url",
        "count(*) as count",
        "sum(count(*)) over() as total_count"
      ).group(Arel.sql ("(#{AhoyCaptain.config.event[:url_column]})"))
                 .order(Arel.sql("count(#{AhoyCaptain.config.event[:url_column]}) desc"))
    end
  end
end
