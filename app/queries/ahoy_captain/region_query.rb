module AhoyCaptain
  class RegionQuery < ApplicationQuery
    def build
      visit_query
        .reselect("region, country, count(concat(region, country)) as count, sum(count(region)) over() as total_count")
        .where.not(region: nil)
        .group("region, country")
        .order(Arel.sql "count(concat(region, country)) desc")
    end
  end
end
