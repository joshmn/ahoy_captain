module AhoyCaptain
  class GoalsPresenter
    attr_reader :goals
    def initialize(event_query)
      @event_query = event_query
      @goals = nil
    end

    def build
      if AhoyCaptain.config.goals.none?
        @goals = []
        return self
      end
      queries = {}
      selects = []
      last_goal = nil
      map = {}
      total_event_count_by_name = @event_query.reselect("count(ahoy_events.name) as total").where(name: AhoyCaptain.config.goals.map(&:event_name)).group("ahoy_events.name").count("distinct ahoy_events.id")
      AhoyCaptain.config.goals.each do |goal|
        queries[goal.id] = @event_query.select("count(distinct(ahoy_events.visit_id)) as uniques, ahoy_events.name as name, count(distinct ahoy_events.id) as total").where(name: goal.event_name).group("ahoy_events.name")
        selects << ["SELECT uniques, name, total from #{goal.id}"]

        map[goal.event_name] = goal
        last_goal = goal
      end
      select = selects.join(" UNION ").delete_suffix(" from #{last_goal.id}")
      select = select.delete_prefix("SELECT ")
      steps = ::Ahoy::Event.with(
        queries,
      ).select(select).from("#{last_goal.id}")

      items = ::Ahoy::Event.with(steps: steps).select("total as total_events, 0 as total_visitors, uniques, name, 0 as conversion_rate").from("steps").index_by(&:name)
      @goals = []
      map.each do |name, _|
        if items[name]
          items[name].name = map[name].title
          items
          items[name].conversion_rate = (((items[name].total_events / total_visitors.to_d) * 100) / 100.to_d).round(2)
          @goals << items[name]
        else
          @goals << OpenStruct.new(name: map[name].title, uniques: 0, total: 0, conversion_rate: 0)
        end
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
