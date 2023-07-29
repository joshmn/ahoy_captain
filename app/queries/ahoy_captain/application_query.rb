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

    # merge both sets of ransackable params and ensure that they're being set on the correct association
    # if we have params that reach across associations
    def ransack_params
      ransackable_params = {}

      if params[:q]
        ransackable_attributes = {
          visit: (AhoyCaptain.visit.ransackable_attributes + AhoyCaptain.visit.ransackable_scopes).map(&:to_s),
          event: (AhoyCaptain.event.ransackable_attributes + AhoyCaptain.event.ransackable_scopes).map(&:to_s),
        }

        pattern = /(?:_not_eq|_eq|_in|_not_in|_cont|_not_cont|_i_cont)$/
        params[:q].each do |key, value|
          attribute_name = key.gsub(pattern, '')
          if self.class.name == "AhoyCaptain::EventQuery" && ransackable_attributes[:visit].include?(attribute_name) || ransackable_attributes[:visit].include?(key)
            ransackable_params["visit_#{key}"] = value
          elsif self.class.name == "AhoyCaptain::VisitQuery" && ransackable_attributes[:event].include?(attribute_name) || ransackable_attributes[:event].include?(key)
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
      if params[:period]
        if self.class.name == "AhoyCaptain::EventQuery"
          ransackable_params['time_gt'] = range[0]
          ransackable_params['time_lt'] = range[1]
          ransackable_params["visit_started_at_gt"] = range[0]
          ransackable_params["visit_started_at_lt"] = range[1]
        elsif self.class.name == "AhoyCaptain::VisitQuery"
          ransackable_params["started_at_gt"] = range[0]
          ransackable_params["started_at_lt"] = range[1]
          ransackable_params["events_time_gt"] = range[0]
          ransackable_params["events_time_lt"] = range[1]
        end
      end


      ransackable_params
    end
  end
end
