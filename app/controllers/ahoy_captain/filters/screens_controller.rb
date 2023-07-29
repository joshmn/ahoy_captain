module AhoyCaptain
  module Filters
    class ScreensController < BaseController
      def index
        query = visit_query.all

        render json: query.select("distinct device_type").where.not(device_type: nil).group(:device_type).order(Arel.sql "count(*) desc").pluck(:device_type).map { |city| serialize(city) }
      end
    end
  end
end
