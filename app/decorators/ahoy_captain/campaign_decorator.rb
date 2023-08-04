module AhoyCaptain
  class CampaignDecorator < ApplicationDecorator

    def self.csv_map(params = {})
      {
        params[:campaigns_type] => :label,
        "Total" => :unit_amount
      }
    end

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
