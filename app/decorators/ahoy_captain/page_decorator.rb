module AhoyCaptain
  class PageDecorator < ApplicationDecorator
    def display_name
      object.url
    end

    def unit_amount
      object.count
    end
  end
end
