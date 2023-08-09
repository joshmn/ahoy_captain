module AhoyCaptain
  module Stats
    class BaseQuery < ApplicationQuery
      include ComparableQuery

      protected

      def self.cast_type(column)
        ActiveRecord::Type.lookup(::Ahoy::Visit.columns_hash[column.to_s].type)
      end

      def self.cast_value(type, value)
        type.cast(value)
      end
    end
  end
end
