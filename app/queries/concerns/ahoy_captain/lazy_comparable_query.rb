module AhoyCaptain
  module LazyComparableQuery
    class LazyComparison
      class LazyComparisonResult
        attr_accessor :current, :compared_to
      end

      include ::AhoyCaptain::ComparableQueries

      def initialize(query)
        @query = query
        @params = @query.params.deep_dup
        @compare = @query.class.call(comparison_params)
      end

      def method_missing(name, *args)
        perform_operations(name, *args)
      end

      def perform_operations(name, *args)
        @query = @query.public_send(name, *args)
        @compare = @compare.public_send(name, *args)

        self
      end

      def result
        return @result if @result

        @result = LazyComparisonResult.new.tap { |comparison| comparison.current =  @query; comparison.compared_to = @compare }
      end
    end

    def with_lazy_comparison(enabled = false)
      if enabled
        LazyComparison.new(self)
      else
        self
      end
    end
  end
end
