require 'ahoy_captain/period_collection'

module AhoyCaptain
  class Configuration
    attr_accessor :view_name, :theme
    attr_reader :goals, :funnels, :cache, :ranges, :disabled_widgets
    def initialize
      @goals = GoalCollection.new
      @funnels = FunnelCollection.new
      @view_name = "$view"
      @theme = "dark"
      @ranges = ::AhoyCaptain::PeriodCollection.load_default
      @cache = ActiveSupport::OrderedOptions.new.tap do |option|
        option.enabled = false
        option.store = Rails.cache
        option.ttl = 1.minute
      end
      @disabled_widgets = []
    end

    def goal(id, &block)
      instance = Goal.new
      instance.id = id
      instance.instance_exec(&block)
      @goals.register(instance)
    end

    def funnel(label, &block)
      instance = Funnel.new
      instance.label = label
      instance.instance_exec(&block)
      @funnels.register(instance)
    end
  end
end
