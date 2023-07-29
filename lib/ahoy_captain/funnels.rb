module AhoyCaptain
  class Funnel
    attr_accessor :label
    attr_reader :goals

    def initialize
      @label = nil
      @goals = []
    end

    def goal(id)
      @goals << id
    end
  end

  class FunnelCollection
    include Enumerable

    def initialize
      @funnels = []
    end

    def register(funnel)
      @funnels << funnel
    end

    def each(&block)
      @funnels.each(&block)
    end
  end
end
