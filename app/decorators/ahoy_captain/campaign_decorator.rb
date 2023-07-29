module AhoyCaptain
  class CampaignDecorator < ApplicationDecorator
    def display_name
      object.label
    end

    def unit_amount
      object.count
    end
  end
end
