module AhoyCaptain
  module Filters
    module Pages
      class EntryPagesController < BaseController
        def index
          query = event_query.all.with_url.distinct_url
          render json: query.map { |row| { text: row.url } }
        end

      end
    end
  end
end
