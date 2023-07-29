module AhoyCaptain
  class RegionDecorator < CountryDecorator
    def display_name
      "#{country_emoji(object.country)} #{object.region}"
    end

    def unit_amount
      object.count
    end
  end
end
