module AhoyCaptain
  class Goal
    attr_accessor :id
    attr_reader :title, :event_name
    def initialize
      @id = nil
      @title = nil
      @event_name = nil
    end

    def label(value)
      @title = value
    end

    def event(value)
      @event_name = value
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
  end
end
