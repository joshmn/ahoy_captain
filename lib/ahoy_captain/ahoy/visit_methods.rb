module AhoyCaptain
  module Ahoy
    module VisitMethods
      extend ActiveSupport::Concern

      included do
        ransacker :ref_domain do
          Arel.sql("(substring(#{self.table_name}.referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)'))")
        end
      end

      class_methods do
        def ransackable_attributes(auth = nil)
          columns_hash.keys + ["ref_domain"]
        end

        def ransackable_associations(auth = nil)
          super + ["events"]
        end
      end
    end
  end
end
