module AhoyCaptain
  module Filters
    module Properties
      class NamesController < BaseController
        def index
          render json: ::Ahoy::Event.select("jsonb_object_keys(properties) as keys").distinct("jsonb_object_keys(properties)").map(&:keys).map { |key| serialize(key) }
        end
      end
    end
  end
end
