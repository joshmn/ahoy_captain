module AhoyCaptain
  module Ahoy
    module VisitMethods
      extend ActiveSupport::Concern

      class_methods do
        def ransackable_attributes(auth = nil)
          columns_hash.keys
        end

        def ransackable_associations(auth = nil)
          [:events]
        end
      end
    end
  end
end
