module AhoyCaptain
  class CityDecorator < CountryDecorator
    def display_name
      search = search_query(country_eq: object.country, city_eq: object.city)
      frame_link("#{country_emoji(object.country)} #{object.city}", path)
    end

    def unit_amount
      object.count
    end
  end
end
