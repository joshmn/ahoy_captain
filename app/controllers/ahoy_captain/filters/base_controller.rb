module AhoyCaptain
  module Filters
    class BaseController < ApplicationController
      include Rangeable

      private

      def serialize(value)
        { text: value }
      end

      def visit_query
        FancyVisitQuery.call(params)
      end
    end
  end
end
