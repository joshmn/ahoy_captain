module AhoyCaptain
  class Funnel
    VALID_STRATEGIES = [:total, :participation].freeze

    attr_accessor :id
    attr_reader :goals
    attr_reader :strategy

    def initialize
      @id = nil
      @label = nil
      @goals = []
      @strategy = :total
    end

    def goal(id)
      @goals << AhoyCaptain.config.goals[id]
    end

    def label(value)
      @label = value
    end

    def strategy(value = nil)
      return @strategy unless value
      
      raise ArgumentError, "Invalid strategy: #{value}. Must be one of: #{VALID_STRATEGIES.join(', ')}" unless VALID_STRATEGIES.include?(value)
      @strategy = value
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
