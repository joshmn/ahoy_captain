module AhoyCaptain
  class RegionDecorator < CountryDecorator
    def display_name
      search = search_query(region_eq: object.region, country_eq: object.country)
      frame_link("#{country_emoji(object.country)} #{object.region}", search)
    end

    def unit_amount
      object.count
    end
  end
end
