module AhoyCaptain
  class CityQuery < ApplicationQuery
    def build
      visit_query
        .select("city, country, count(concat(city, region, country)) as count, sum(count(concat(city, region, country))) over() as total_count")
        .where.not(city: nil)
        .group("city, region, country")
        .order(Arel.sql "count(concat(city, region, country)) desc")
    end
  end
end
