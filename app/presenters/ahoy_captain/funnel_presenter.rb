module AhoyCaptain
  # this is incredibly naive and needs some tlc
  class FunnelPresenter

    attr_reader :steps
    def initialize(funnel, event_query)
      @funnel = funnel
      @event_query = event_query.joins(:visit)
    end

    def build
      queries = {}
      prev_goal = nil
      prev_table = nil
      selects = []
      @funnel.goals.each do |goal|
        if prev_goal
          query = ::Ahoy::Event
                    .select("distinct ahoy_events.visit_id")
                    .from(prev_table.to_s)
                    .joins("inner join ahoy_events on ahoy_events.visit_id = #{prev_table}.id")
                    .where("ahoy_events.name = ?", goal.event_name.to_s).to_sql
          prev_table = "#{goal.id}"
          selects << ["SELECT '#{prev_goal.title} > #{goal.title}' as step, count(*) from #{prev_table}"]
          queries[prev_table] = query
        else
          prev_table = :visitors
          prev_goal = goal

          query = @event_query
                    .select("distinct(visit_id) as id, min(time) as min_time")
                    .where(name: goal.event_name.to_s)
                    .group("1").to_sql
          selects << ["'#{goal.title}' as step, count(*) from #{prev_table}"]

          queries[prev_table] = query
        end
      end

      select = selects.join(" UNION ").delete_suffix(" from #{prev_table}")

      steps = ::Ahoy::Event.with(
        queries
      ).select(select).from(prev_table).order("count desc")

      @steps = ::Ahoy::Event.with(steps: steps).select("step, count, lag(count, 1) over () as lag, abs(count::numeric - lag(count, 1) over ())::integer as drop_off, round((1.0 - count::numeric/lag(count, 1) over ()),2) as conversion_rate").from("steps")
      self
    end

    def total
      @event_query.distinct(:visitor_token).count
    end

    def as_json
      {
        steps: @steps.as_json,
        total: total
      }
    end

    def to_json
      as_json.to_json
    end
  end
end
