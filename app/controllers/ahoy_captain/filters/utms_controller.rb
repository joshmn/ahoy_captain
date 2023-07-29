module AhoyCaptain
  module Filters
    class UtmsController < BaseController
      def index
        query = visit_query.select("#{params[:type]}", "count(#{params[:type]}) as total").group(params[:type]).order(Arel.sql "count(#{params[:type]}) desc").pluck(params[:type]).map { |city| serialize(city || "Direct/none") }
        render json: query
      end
    end
  end
end
