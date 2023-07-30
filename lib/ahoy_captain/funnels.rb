module AhoyCaptain
  class Funnel
    attr_accessor :label
    attr_reader :goals

    def initialize
      @label = nil
      @goals = []
    end

    def goal(id)
      @goals << AhoyCaptain.config.goals[id]
    end
  end

  class FunnelCollection
    include Enumerable

    def initialize
      @funnels = {}
    end

    def register(funnel)
      @funnels[funnel.label] = funnel
    end

    def each(&block)
      @funnels.each(&block)
    end

    def [](value)
      @funnels[value]
    end
  end
end
