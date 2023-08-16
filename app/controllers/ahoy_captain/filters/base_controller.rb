module AhoyCaptain
  module Filters
    class BaseController < ApplicationController
      private

      def serialize(value)
        { text: (value.presence || AhoyCaptain.none.text), value: (value.presence || AhoyCaptain.none.value) }
      end

      def visit_query
        VisitQuery.call(params)
      end
    end
  end
end
