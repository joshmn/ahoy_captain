module AhoyCaptain
  module Filters
    module Pages
      class ExitPagesController < BaseController
        def index
          query = event_query.with_url.distinct_url

          render json: query.map { |row| { text: row.url } }
        end

      end
    end
  end

end
