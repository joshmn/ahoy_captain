module AhoyCaptain
  class RegionDecorator < CountryDecorator
    def self.csv_map(params = {})
      {
        "Country" => :country,
        "Region" => :region,
        "Total" => :unit_amount
      }
    end

    def display_name
      search = search_query(region_eq: object.region, country_eq: object.country)
      frame_link("#{country_emoji(object.country)} #{object.region}", search)
    end

    def country
      "#{country_emoji(object.country)} #{object.country}"
    end

    def region
      object.region
    end

    def unit_amount
      object.count
    end
  end
end
