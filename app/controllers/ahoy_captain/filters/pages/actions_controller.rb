module AhoyCaptain
  module Filters
    module Pages
      class ActionsController < BaseController
        def index
          query = ::AhoyCaptain.event.ransack(query_with_search)
          results = query.result.select("#{AhoyCaptain.config.event[:url_column]} as url").distinct("(#{AhoyCaptain.config.event[:url_column]})")
          rows = []
          results.each do |result|
            rows << result.url
          end

          render json: rows.map { |row| { text: row } }
        end

        private

        def query_with_search
          (params[:q] || {}).reject { |k, v| k.start_with?('country') }.tap do |ransack_params|
            ransack_params[:country_i_cont] = params[:search]
          end
        end
      end
    end
  end
end
