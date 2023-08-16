module AhoyCaptain
  module Filters
    module Pages
      class ActionsController < BaseController
        def index
          query = event_query.all.with_url.distinct_url

          render json: query.map { |row| serialize(row.url) }
        end
      end
    end
  end
end
