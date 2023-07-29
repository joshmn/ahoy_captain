module AhoyCaptain
  class CityDecorator < CountryDecorator
    def display_name
      "#{country_emoji(object.country)} #{object.city}"
    end

    def unit_amount
      object.count
    end
  end
end