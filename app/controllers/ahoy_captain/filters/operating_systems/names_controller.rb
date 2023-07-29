module AhoyCaptain
  module Filters
    module OperatingSystems
      class NamesController < BaseController
        def index
          query = visit_query.all

          render json: query.select("distinct os").where.not(os: nil).group(:os).order(Arel.sql "count(*) desc").pluck(:os).map { |city| serialize(city) }
        end
      end
    end
  end
end
