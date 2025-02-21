module AhoyCaptain
  class StrategyFactory
    STRATEGIES = {
      total: Strategies::TotalEvents,
      participation: Strategies::UserParticipation
    }.freeze

    def self.build(strategy_name, event_query)
      strategy_class = STRATEGIES[strategy_name] || STRATEGIES[:total]
      strategy_class.new(event_query)
    end
  end
end