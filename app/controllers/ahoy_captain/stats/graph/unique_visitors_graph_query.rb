module AhoyCaptain
  module Stats
    module Graph
      class UniqueVisitorsGraphQuery < BaseQuery
        def build
          interval = params.delete(:selected_interval)
          ::Ahoy::Visit.with(
            current: UniqueVisitorsQuery.call(params).group_by_period(interval, :started_at),
            previous: comparison_query.group_by_period(interval, :started_at),
            ).select("count(distinct current.visitor_token) as current, count(distinct previous.visitor_token) as previous").from("current, previous")
        end

        private

        def comparison_query
          if compare?
            UniqueVisitorsQuery.call(comparison_params)
          else
            ::Ahoy::Visit.select("null as visitor_token, 0::date as started_at").where("1 = 1").limit(1)
          end
        end
      end
    end
  end
end
