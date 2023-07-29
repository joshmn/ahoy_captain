module AhoyCaptain
  module Filters
    module OperatingSystems
      class NamesController < BaseController
        def index
          query = visit_query.within_range.ransack(params[:q])

          render json: query.result.select("distinct os").where.not(os: nil).group(:os).order(Arel.sql "count(*) desc").pluck(:os).map { |city| serialize(city) }
        end
      end
    end
  end
end
