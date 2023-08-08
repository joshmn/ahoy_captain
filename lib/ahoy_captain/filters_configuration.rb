module AhoyCaptain
  class FiltersConfiguration
    def self.load_default
      new.tap do |config|
        config.register("Page") do
          filter :route, "Route", :filters_actions_path, [:in, :not_in]
          filter :entry_page, "Entry Page", :filters_entry_pages_path, [:in, :not_in]
          filter :exit_page, "Exit Page", :filters_exit_pages_path, [:in, :not_in]
        end
      end
    end

    class FilterCollection

      class Filter
        attr_accessor :label, :column, :url, :predicates

        def initialize(label, column, url, predicates = [])
          @label = label
          @column = column
          @url = url
          @predicates = predicates
        end
      end

      def initialize(label)
        @label = label
        @filters = {}
      end

      def filter(label, column, url, predicates = [])
        @filters[column] = Filter.new(label, column, url, predicates)
      end

      def each(&block)
        @filters.each(&block)
      end
    end

    def initialize
      @registry = {}
    end

    def register(label, &block)
      item = FilterCollection.new(label)
      item.instance_exec(&block)
      @registry[label] = item
    end

    def each(&block)
      @registry.each(&block)
    end
  end
end
