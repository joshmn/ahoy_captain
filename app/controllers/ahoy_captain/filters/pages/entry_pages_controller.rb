module AhoyCaptain
  module Filters
    module Pages
      class EntryPagesController < BaseController
        def index
          query = event_query.all.distinct("entry_pages.url").select("entry_pages.url as url")

          render json: query.map { |row| serialize(row.url) }
        end

      end
    end
  end
end
