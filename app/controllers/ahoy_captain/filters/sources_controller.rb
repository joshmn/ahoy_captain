module AhoyCaptain
  module Filters
    class SourcesController < BaseController
      def index
        query = visit_query.all

        render json: query.result.select("distinct referring_domain").where.not(referring_domain: nil).group(:referring_domain).order(Arel.sql "count(*) desc").pluck(:referring_domain).map { |city| serialize(city) }
      end
    end
  end
end
