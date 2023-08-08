module AhoyCaptain
  class FilterConfiguration
    class FilterCollection
      def initialize(label)
        @label = label
        @registry = []
      end

      def filter(label:, column:, url:, predicates: [:in, :not_in], multiple: true, position: nil)
        position ||= @registry.size
        if item = find(column)
          @registry.delete(item)
        end

        @registry << FilterConfiguration::Filter.new(label: label, column: column, url: url, predicates: predicates, multiple: multiple, position: position)
        @registry = @registry.sort_by { |filter| filter.position }
      end

      def each(&block)
        @registry.each(&block)
      end

      def modal_name
        "#{@label.parameterize.underscore}Modal"
      end

      def find(column)
        @registry.find { |filter| filter.column == column.to_sym }
      end

      def delete(name)
        @registry.delete_if { |filter| filter.column == name }
      end

      def filters
        @registry
      end

      def [](name)
        find(name)
      end

      def include?(name)
        find(name).present?
      end
    end
  end
end
