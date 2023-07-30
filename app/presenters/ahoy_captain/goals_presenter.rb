module AhoyCaptain
  class GoalsPresenter
    attr_reader :goals
    def initialize(event_query)
      @event_query = event_query
      @goals = nil
    end

    def build
      queries = {}
      selects = []
      last_goal = nil
      map = {}
      AhoyCaptain.config.goals.each do |goal|
        queries[goal.id] = @event_query.select("count(distinct(visit_id)) as uniques, count(name) as total, name").where(name: goal.event_name).group("name")
        selects << ["SELECT total, uniques, name from #{goal.id}"]
        map[goal.event_name] = goal
        last_goal = goal
      end
      select = selects.join(" UNION ").delete_suffix(" from #{last_goal.id}")
      select = select.delete_prefix("SELECT ")
      steps = ::Ahoy::Event.with(
        queries
      ).select(select).from("#{last_goal.id}")

      items = ::Ahoy::Event.with(steps: steps).select("total, uniques, name, 0 as conversion_rate").from("steps").index_by(&:name)
      @goals = []
      map.each do |name, _|
        if items[name]
          items[name].name = map[name].title
          items[name].conversion_rate = ((items[name].total / total.to_d) * 100).round(2) * 100
          @goals << items[name]
        else
          @goals << OpenStruct.new(name: map[name].title, uniques: 0, total: 0, conversion_rate: 0)
        end
      end

      self
    end

    def total
      @total ||= @event_query.distinct(:visitor_token).count
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
