module AhoyCaptain
  module Filters
    module OperatingSystems
      class VersionsController < BaseController
        def index
          query = visit_query.all

          render json: query.select("distinct os_version").where.not(os_version: nil).group(:os_version).order(Arel.sql "count(*) desc").pluck(:os_version).map { |city| serialize(city) }
        end
      end
    end
  end
end
