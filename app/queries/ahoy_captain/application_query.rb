require_relative '../concerns/ahoy_captain/comparable_queries'

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

        pattern = /(?:#{Ransack.predicates.sorted_names_with_underscores.to_h.values.join("|")})$/
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

      merge_params = {}
      ransackable_params.each do |k,v|
        transform = false
        if v == AhoyCaptain.none.value
          transform = true
        elsif v.is_a?(Array) && v[0] == AhoyCaptain.none.value
          transform = true
        end

        if transform
          key = k.dup
          ransackable_params.delete(key)
          predicate = Ransack::Predicate.detect_and_strip_from_string!(key)
          if predicate.include?("not")
            merge_params["#{key}_not_null"] = '1'
          else
            merge_params["#{key}_null"] = '1'
          end
        end
      end

      ransackable_params.merge!(merge_params)
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

      ransackify(ransackable_params, type)
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

    def ransackify(query, type)
      return unless query

      query = query.try(:permit!).try(:to_h) unless query.is_a?(Hash)
      obj = query.each_with_object({}) do |(k, v), obj|
        if k.starts_with?('properties.')
          field = k.split('properties.').last
          operation = Ransack::Predicate.detect_and_strip_from_string!(field)

          raise ArgumentError, "No valid predicate for #{field}" unless operation

          prefix = type == :event ? "" : "events_"
          obj[:c] ||= []

          obj[:c] << {
            a: {
              '0' => {
                name: "#{prefix}properties",
                ransacker_args: field
              }
            },
            p: operation,
            v: [v]
          }

        else
          obj[k] = v
        end
      end

      if type == :event
        return obj
      else
        return obj
      end
    end

    def range
      RangeFromParams.from_params(params)
    end
  end
end
