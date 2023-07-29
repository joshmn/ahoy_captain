module AhoyCaptain
  module Filters
    module Pages
      # TODO: ACCOMODATE EXIT_PAGES
      class EntryPagesController < BaseController
        def index
          result = ::AhoyCaptain.event
                     .select("#{AhoyCaptain.config.event[:url_column]} as url").distinct("(#{AhoyCaptain.config.event[:url_column]})")
                     .where(name: AhoyCaptain.config.view_name)
                     .joins("INNER JOIN (SELECT MIN(id) AS max_id FROM #{::AhoyCaptain.event.table_name} GROUP BY visit_id) last_events ON #{::AhoyCaptain.event.table_name}.id = last_events.max_id")
          if routes = params.dig(:q, :route_in)
            other_query = event_query
            routes.each do |route|
              cname, aname = route.split("#", 2)
              other_query = other_query.where("#{::AhoyCaptain.event.table_name}.properties->>'controller' = ? AND #{::AhoyCaptain.event_name}.properties->>'action' = ?", cname, aname)
            end
            result = result.where(visit_id: other_query.pluck(:visit_id))
          end

          result = result.with_routes

          render json: result.map { |row| { text: row.url } }
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
