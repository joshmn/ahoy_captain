module AhoyCaptain
  module ComparableQuery
    class Comparison
      class ComparisonResult
        attr_reader :current, :compared_to
        def initialize(current, compared_to)
          @current = current
          @compared_to = compared_to
        end
      end

      def initialize(query)
        @query = query
        @compare = @query.class.call(comparison_params)
        @model = @query.all.klass
        @query_class = @query.class
      end

      def count(column_name = :id)
        @operation = :count
        @column = column_name
        perform_calculations(:count, column_name)

        self
      end

      def average(column_name)
        @operation = :average
        @column = column_name

        perform_calculations(:average, column_name)

        self
      end

      def perform_calculations(operation, column_name)
        @query = perform_calculation(@query, operation, column_name)
        @compare = perform_calculation(@compare, operation, column_name)
      end

      def perform_calculation(q, operation, column_name)
        operation = operation.to_s.downcase
        # If #count is used with #distinct (i.e. `relation.distinct.count`) it is
        # considered distinct.
        distinct = q.send(:distinct_value)

        if operation == "count"
          column_name ||= q.send(:select_for_count)
          if column_name == :all
            if !distinct
              distinct = q.send(:distinct_select?, :select_for_count) if q.group_values.empty?
            elsif q.send(:group_values).any? || q.send(:select_values).empty? && q.order_values.empty?
              column_name = q.primary_key
            end
          elsif q.all.send(:distinct_select?, column_name)
            distinct = nil
          end
        end

        if q.group_values.any?
          q.send(:execute_grouped_calculation, operation, column_name, distinct)
        else
          execute_simple_calculation(q, operation, column_name, distinct)
        end
      end

      def result
        result = @model.with(
          current: @query.to_sql,
          compare: @compare.to_sql
        ).select("current, compare").from("current, compare")[0]

        type = @query_class.cast_type(@column)

        current = @query_class.cast_value(type, result.current[1...-1])
        compare = @query_class.cast_value(type, result.compare[1...-1])

        ComparisonResult.new((current), (compare))
      end


      private

      def execute_simple_calculation(q, operation, column_name, distinct) # :nodoc:
        if operation == "count" && (column_name == :all && distinct || q.has_limit_or_offset?)
          # Shortcut when limit is zero.
          return 0 if q.limit_value == 0

          query_builder = q.send(:build_count_subquery, q.spawn, column_name, distinct)
        else
          # PostgreSQL doesn't like ORDER BY when there are no GROUP BY
          relation = q.all.unscope(:order).distinct!(false)

          column = q.all.send(:aggregate_column, column_name)
          select_value = q.all.send(:operation_over_aggregate_column, column, operation, distinct)
          select_value.distinct = true if operation == "sum" && distinct

          relation.select_values = [select_value]

          query_builder = relation.arel
        end

      end

      def comparison_params
        params = @query.send(:params).deep_dup
        og_range = @query.send(:range)
        params.delete("period")

        params[:start_date] = og_range[0] - (og_range[1] - og_range[0])
        params[:end_date] = og_range[0]
        params
      end
    end

    def with_comparison
      Comparison.new(self)
    end
  end
end
