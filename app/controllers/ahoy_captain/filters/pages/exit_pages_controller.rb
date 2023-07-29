module AhoyCaptain
  module Filters
    module Pages
      # TODO: ACCOMODATE ENTRY_PAGES
      class ExitPagesController < BaseController
        def index
          result = ::Ahoy::Event
                     .select("#{::Ahoy::Event.captain_url_signature} as url").distinct("(#{::Ahoy::Event.captain_url_signature})")
                     .where(name: AhoyCaptain.config.view_name)
                     .joins("INNER JOIN (SELECT MAX(id) AS max_id FROM #{::Ahoy::Event.table_name} GROUP BY visit_id) last_events ON #{::Ahoy::Event.table_name}.id = last_events.max_id")
          if routes = params.dig(:q, :route_in)
            other_query = ::Ahoy::Event.all
            routes.each do |route|
              cname, aname = route.split("#", 2)
              other_query = other_query.where("#{::Ahoy::Event.table_name}.properties->>'controller' = ? AND #{::Ahoy::Event.table_name}.properties->>'action' = ?", cname, aname)
            end
            result = result.where(visit_id: other_query.pluck(:visit_id))
          end

          result = result.where("JSONB_EXISTS(properties, 'controller') AND JSONB_EXISTS(properties, 'action')")

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
