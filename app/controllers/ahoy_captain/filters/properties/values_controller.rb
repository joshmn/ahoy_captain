module AhoyCaptain
  module Filters
    module Properties
      class ValuesController < BaseController
        def index
          param_key = event_query.params[:q].to_unsafe_h.detect { |k,v| k.ends_with?("_i_cont") && k.starts_with?("properties.") }[0]
          key = param_key.delete_prefix("properties.").delete_suffix("_i_cont")
          query = event_query.all.distinct.select("properties->>'#{key}'").pluck(Arel.sql "properties->>'#{key}'")

          render json: query.map { |element| serialize(element) }
        end
      end
    end
  end
end
