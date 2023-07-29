module AhoyCaptain
  module Filters
    module Pages
      # TODO: ACCOMODATE ENTRY_PAGES
      class ExitPagesController < BaseController
        def index
          query = event_query.within_range.with_url.distinct_url

          render json: query.map { |row| { text: row.url } }
        end

      end
    end
  end

end
