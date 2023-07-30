module AhoyCaptain
  class Funnel
    attr_accessor :id
    attr_reader :goals

    def initialize
      @id = nil
      @label = nil
      @goals = []
    end

    def goal(id)
      @goals << AhoyCaptain.config.goals[id]
    end

    def label(value)
      @label = value
    end

    def title
      @label
    end
  end

  class FunnelCollection
    include Enumerable

    def initialize
      @funnels = {}
    end

    def register(funnel)
      @funnels[funnel.id] = funnel
    end

    def each(&block)
      @funnels.each(&block)
    end

    def [](value)
      @funnels[value.to_sym]
    end
  end
end
