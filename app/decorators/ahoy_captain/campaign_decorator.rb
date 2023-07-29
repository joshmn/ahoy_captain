module AhoyCaptain
  class CampaignDecorator < ApplicationDecorator
    def display_name
      if object.label == "Direct/None"
        value = ""
      else
        value = object.label
      end

      search = search_query("#{params[:campaigns_type]}_eq" => value)

      frame_link(object.label, search)
    end

    def unit_amount
      object.count
    end
  end
end
