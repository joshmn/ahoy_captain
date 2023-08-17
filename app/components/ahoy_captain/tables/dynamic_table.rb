module AhoyCaptain
  module Tables
    class DynamicTable
      def self.register(options = {}, &block)
        @table ||= DynamicTableComponent.build(self, options, &block)
      end

      def self.table
        @table
      end
    end
  end
end
