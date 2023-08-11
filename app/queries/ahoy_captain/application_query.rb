require_relative '../concerns/comparable_queries'

module AhoyCaptain
  class ApplicationQuery
    # if you want to enforce returning a relation
    class_attribute :strict, default: true

    delegate_missing_to :@query

    def self.inherited(klass)
      klass.protected_methods :build
      klass.private_methods :call
    end

    def self.call(params, query = nil)
      new(params, query).send(:call)
    end

    attr_reader :params
    def initialize(params, query)
      @params = params
      @query = query
    end

    def inspect
      "<#{self.class.name}>"
    end
    protected

    def build
      raise NotImplementedError
    end

    private

    def call
      @query = build

      if self.class.strict?
        if @query.is_a?(ActiveRecord::Relation) || @query.class != self.class
        else
          raise ArgumentError, "#{self.class.name} has strict enabled, and should return a relation. Returned a #{@query.class}."
        end
      end

      self
    end

    def visit_query
      VisitQuery.call(params)
    end

    def event_query
      EventQuery.call(params)
    end

    # this could be better
    def ransack_params_for(type)
      ransackable_params = {}

      if params[:q]
        ransackable_attributes = {
          visit: (AhoyCaptain.visit.ransackable_attributes + AhoyCaptain.visit.ransackable_scopes).map(&:to_s),
          event: (AhoyCaptain.event.ransackable_attributes + AhoyCaptain.event.ransackable_scopes).map(&:to_s),
        }

        pattern = /(?:_not_eq|_eq|_in|_not_in|_cont|_not_cont|_i_cont)$/
        params[:q].each do |key, value|
          attribute_name = key.gsub(pattern, '')
          if type == :event && (ransackable_attributes[:visit].include?(attribute_name) || ransackable_attributes[:visit].include?(key))
            ransackable_params["visit_#{key}"] = value
          elsif type == :visit && (ransackable_attributes[:event].include?(attribute_name) || ransackable_attributes[:event].include?(key))
            ransackable_params["events_#{key}"] = value
          else
            ransackable_params[key] = value
          end
        end
      end

      # send the right format
      #   ::Ahoy::Visit.ransack(events_time_lt: Time.now).result.to_sql
      # is not
      #   ::Ahoy::Visit.ransack(events_time_lt: Time.now.to_i).result.to_sql
      if range
        if type == :event
          if range.realtime?
            ransackable_params['time_gt'] = range[0]
            ransackable_params["visit_started_at_gt"] = range[0]
          else
            ransackable_params['time_gt'] = range[0]
            ransackable_params['time_lt'] = range[1]
            ransackable_params["visit_started_at_gt"] = range[0]
            ransackable_params["visit_started_at_lt"] = range[1]
          end
        elsif type == :visit
          if range.realtime?
            ransackable_params["started_at_gt"] = range[0]
            ransackable_params["events_time_gt"] = range[0]
          else
            ransackable_params["started_at_gt"] = range[0]
            ransackable_params["started_at_lt"] = range[1]
            ransackable_params["events_time_gteq"] = range[0]
            ransackable_params["events_time_lteq"] = range[1]
          end
        end
      end

      ransackable_params
    end

    # merge both sets of ransackable params and ensure that they're being set on the correct association
    # if we have params that reach across associations
    def ransack_params
      if self.class.name == "AhoyCaptain::EventQuery"
        ransack_params_for(:event)
      elsif self.class.name == "AhoyCaptain::VisitQuery"
        ransack_params_for(:visit)
      else
        raise ArgumentError, "use ransack_params_for(type)"
      end
    end

    def range
      RangeFromParams.from_params(params)
    end
  end
end
