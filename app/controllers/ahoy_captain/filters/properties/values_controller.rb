module AhoyCaptain
  module Filters
    module Properties
      class ValuesController < BaseController
        def index
          query = event_query.all
          abort
          things = ::Ahoy::Event.with(elements: query).select("elements.property_value").from("elements")
          abort
          render json: query.map(&:element).map { |element| serialize(element) }
        end
      end
    end
  end
end
