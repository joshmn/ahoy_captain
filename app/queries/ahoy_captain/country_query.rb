module AhoyCaptain
  class CountryQuery < ApplicationQuery
    def build
      visit_query
        .reselect("country as label, count(country) as count, sum(count(country)) OVER() as total_count")
        .group("country")
        .order("count(country) desc")
    end
  end
end
