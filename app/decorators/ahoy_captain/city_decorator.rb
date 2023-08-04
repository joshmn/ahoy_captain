module AhoyCaptain
  class CityDecorator < CountryDecorator
    def self.csv_map(params = {})
      {
        "Country" => :country,
        "City" => :city,
        "Total" => :unit_amount
      }
    end

    def display_name
      search = search_query(country_eq: object.country, city_eq: object.city)
      frame_link("#{country_emoji(object.country)} #{object.city}", search)
    end

    def country
      "#{country_emoji(object.country)} #{object.country}"
    end

    def unit_amount
      object.count
    end
  end
end
