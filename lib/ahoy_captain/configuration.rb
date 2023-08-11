require 'ahoy_captain/period_collection'
require 'ahoy_captain/filters_configuration'

module AhoyCaptain
  class Configuration
    attr_accessor :view_name, :theme, :realtime_interval
    attr_reader :goals, :funnels, :cache, :ranges, :disabled_widgets, :event, :models, :filters, :predicate_labels
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
      @models = ActiveSupport::OrderedOptions.new.tap do |option|
        option.event = "::Ahoy::Event"
        option.visit = "::Ahoy::Visit"
      end
      @event = ActiveSupport::OrderedOptions.new.tap do |option|
        option.view_name = "$view"
        option.url_column = "CONCAT(#{@models.event.parameterize.tableize}.properties->>'controller', '#', #{@models.event.parameterize.tableize}.properties->>'action')"
        option.url_exists = "JSONB_EXISTS(#{@models.event.parameterize.tableize}.properties, 'controller') AND JSONB_EXISTS(#{@models.event.parameterize.tableize}.properties, 'action')"
      end
      @filters = FiltersConfiguration.load_default
      @predicate_labels = {
        eq: 'equals',
        not_eq: 'not equals',
        cont: 'contains',
        in: 'in',
        not_in: 'not in',
      }

      @realtime_interval = 30.seconds
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
