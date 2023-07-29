module AhoyCaptain
  module Filters
    class LocationsController < BaseController
      def index
        query = visit_query.within_range.ransack(params[:q])

        render json: query.result.select("distinct #{params[:type]}").where.not(params[:type] => nil).group(params[:type]).order(Arel.sql "count(*) desc").limit(50).pluck(params[:type]).map { |city| serialize(city) }
      end
    end
  end
end
