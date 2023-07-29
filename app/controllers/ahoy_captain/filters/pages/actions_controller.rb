module AhoyCaptain
  module Filters
    module Pages
      class ActionsController < BaseController
        def index
          query = ::Ahoy::Event.ransack(query_with_search)
          results = query.result.select("#{::Ahoy::Event.captain_url_signature} as url").distinct("(#{::Ahoy::Event.captain_url_signature})")
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
