module AhoyCaptain
  module Filters
    module Pages
      class ExitPagesController < BaseController
        def index
          query = event_query.distinct("exit_pages.url").select("exit_pages.url as url")

          render json: query.map { |row| serialize(row.url) }
        end

      end
    end
  end

end
