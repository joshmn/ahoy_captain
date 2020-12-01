# frozen_string_literal: true

module Caffeinate
  module Dripper
  # Includes batch support for setting the batch size for Perform
    module Batching
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def batch_size=(num)
          @batch_size = num
        end

        def batch_size
          @batch_size || ::Caffeinate.config.batch_size
        end
      end
    end
  end
end
