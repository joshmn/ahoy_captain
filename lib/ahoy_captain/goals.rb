module AhoyCaptain
  class Goal
    attr_accessor :id
    attr_reader :title, :event_query
    def initialize
      @id = nil
      @title = nil
      @event_query = nil
    end

    def label(value)
      @title = value
    end

    def name(value)
      @event_query = -> { ::AhoyCaptain.event.where(name: value) }
    end

    def event(value)
      ActiveSupport::Deprecation.warn(
        "event is deprecated. " \
    "Use name instead."
      )
      @event_query = -> { ::AhoyCaptain.event.where(name: value) }
    end

    def query(&block)
      @event_query = block
    end
  end

  class GoalCollection
    include Enumerable

    def initialize
      @goals = {}
    end

    def register(goal)
      @goals[goal.id] = goal
    end

    def each(&block)
      @goals.values.each(&block)
    end

    def [](value)
      @goals[value]
    end
  end
end
