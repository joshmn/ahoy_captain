module AhoyCaptain
  class GoalsPresenter
    attr_reader :goals
    def initialize(event_query)
      @event_query = event_query
      @goals = nil
    end

    # this is a dumpster fire
    def build
      if AhoyCaptain.config.goals.none?
        @goals = []
        return self
      end

      queries = {
        totals: @event_query.select("count(distinct(#{AhoyCaptain.event.table_name}.visit_id)) as unique_visits, '_internal_total_visits_' as name, count(distinct #{AhoyCaptain.event.table_name}.id) as total_events, 0 as sort_order")
      }
      selects = ["SELECT unique_visits, name, total_events, sort_order, 0 as cr, '' as goal_id from totals"]
      last_goal = nil
      map = {}.with_indifferent_access

      AhoyCaptain.config.goals.each_with_index do |goal, index|
        queries[goal.id] = @event_query.select(
          [
            "count(distinct(#{AhoyCaptain.event.table_name}.visit_id)) as unique_visits" ,
            "'#{goal.id}' as name",
            "count(distinct #{AhoyCaptain.event.table_name}.id) as total_events",
            "#{index + 1} as sort_order",
            "'#{goal.id}' as goal_id"
          ]
        ).merge(goal.event_query.call).group("#{AhoyCaptain.event.table_name}.name")
        selects << ["SELECT unique_visits, name, total_events, sort_order, 0::decimal as cr, '#{goal.id}' as goal_id from #{goal.id}"]
        map[goal.id] = goal
        last_goal = goal
      end

      # activerecord quirk / with bug
      select = selects.join(" UNION ").delete_suffix(" from #{last_goal.id}")
      select = select.delete_prefix("SELECT ")
      steps = ::Ahoy::Event.with(
        queries,
        ).select(select).from("#{last_goal.id}").order("sort_order asc").index_by(&:name)
      totals = steps.delete("_internal_total_visits_")

      @goals = steps.keys.collect do |name|
        step = steps[name]
        step.name = map[name].title
        step.cr = ((step.total_events.to_d / totals.total_events.to_d) * 100).round(2)
        step
      end
      self
    end

    def total_visitors
      @total_visitors ||= @event_query.select(:visit_id).distinct.count
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
