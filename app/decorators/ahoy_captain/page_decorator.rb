module AhoyCaptain
  class PageDecorator < ApplicationDecorator
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
