module AhoyCaptain
  class ApplicationQuery
    # if you want to enforce returning a relation
    class_attribute :strict, default: true

    delegate_missing_to :@query

    def self.inherited(klass)
      klass.protected_methods :build
      klass.private_methods :call
    end

    def self.call(params)
      new(params).send(:call)
    end

    attr_reader :params
    def initialize(params)
      @params = params
      @query = nil
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
  end
end
