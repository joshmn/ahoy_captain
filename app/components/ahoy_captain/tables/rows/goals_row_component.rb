module AhoyCaptain
  module Tables
    module Rows
      class GoalsRowComponent < RowComponent

        def search_params
          view_context.search_params
        end

        def url
          AhoyCaptain::Engine.app.url_helpers.root_path + "?#{search_params.dup.except(:goal).merge(goal_id: @item.goal_id).to_query}"
        end

        def total
          @item.total_count
        end
      end
    end
  end
end
