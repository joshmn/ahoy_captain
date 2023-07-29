module AhoyCaptain
  module Filters
    class UtmsController < BaseController
      def index
        query = visit_query.all

        render json: query.select("distinct #{params[:type]}").where.not(params[:type] => nil).group(params[:type]).order(Arel.sql "count(*) desc").pluck(params[:type]).map { |city| serialize(city) }
      end
    end
  end
end
