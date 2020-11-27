module Caffeinate
  module Batching
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def batch_size(num)
        @_batch_size = num
      end

      def _batch_size
        @_batch_size || ::Caffeinate.config.batch_size
      end
    end
  end
end
