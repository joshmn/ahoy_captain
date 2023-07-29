module AhoyCaptain
  class SourceDecorator < ApplicationDecorator
    def display_name

      display = %Q(
        <div class='flex justify-start space-x-8 col-span-1'>
          <img class='transparent w-5 h-5 mt-2'
            src='https://www.google.com/s2/favicons?domain=#{object.referring_domain}&sz=32'
          />
          <span>#{object.referring_domain}</span>
        </div>
      ).html_safe
      path = search_query(ref_domain_eq: object.referring_domain)
      frame_link(display, path)
    end

    def unit_amount
      object.count
    end
  end
end
