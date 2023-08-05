module AhoyCaptain
  module Filters
    module Properties
      class ValuesController < BaseController
        def index
          query = ::Ahoy::Event.with(elements: event_query.select("ahoy_events.properties->>'controller' as element"))
                               .select("distinct elements.element").from("elements")

          render json: query.map(&:element).map { |element| serialize(element) }
        end
      end
    end
  end
end
