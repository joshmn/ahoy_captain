module AhoyCaptain
  module Tables
    module Rows
      class GoalsRowComponent < RowComponent
        def search_params
          view_context.search_params
        end

        def url
          query = search_params.dup.merge(q: { goal_in: @item.goal_id}).to_query
          AhoyCaptain::Engine.app.url_helpers.root_path + "?#{query}"
        end

        def total
          @item.total_count
        end
      end
    end
  end
end
