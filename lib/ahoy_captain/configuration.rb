require 'ahoy_captain/period_collection'

module AhoyCaptain
  class Configuration
    attr_accessor :view_name, :theme
    attr_reader :goals, :funnels, :cache, :ranges, :disabled_widgets, :event, :models
    def initialize
      @goals = GoalCollection.new
      @funnels = FunnelCollection.new
      @theme = "dark"
      @ranges = ::AhoyCaptain::PeriodCollection.load_default
      @cache = ActiveSupport::OrderedOptions.new.tap do |option|
        option.enabled = false
        option.store = Rails.cache
        option.ttl = 1.minute
      end
      @event = ActiveSupport::OrderedOptions.new.tap do |option|
        option.view_name = "$view"
        option.url_column = "COALESCE(ahoy_events.properties->>'url', CONCAT(ahoy_events.properties->>'controller', '#', ahoy_events.properties->>'action'))"
        option.url_exists = "(JSONB_EXISTS(ahoy_events.properties, 'controller') AND JSONB_EXISTS(ahoy_events.properties, 'action')) OR (JSONB_EXISTS(ahoy_events.properties, 'url'))"
      end
      @models = ActiveSupport::OrderedOptions.new.tap do |option|
        option.event = "::Ahoy::Event"
        option.visit = "::Ahoy::Visit"
      end
      @disabled_widgets = []
    end

    def goal(id, &block)
      instance = Goal.new
      instance.id = id
      instance.instance_exec(&block)
      @goals.register(instance)
    end

    def funnel(id, &block)
      instance = Funnel.new
      instance.id = id
      instance.instance_exec(&block)
      @funnels.register(instance)
    end
  end
end
