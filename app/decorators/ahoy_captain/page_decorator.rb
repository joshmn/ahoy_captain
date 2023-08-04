module AhoyCaptain
  class PageDecorator < ApplicationDecorator
    def self.csv_map(params = {})
      {
        "URL" => :label,
        "Total" => :unit_amount
      }
    end

    def label
      object.url
    end

    def display_name
      search = search_query(type => object.url)
      frame_link(object.url, search)
    end

    def unit_amount
      object.count
    end

    def type
      raise NotImplementedError
    end
  end
end
