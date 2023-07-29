module AhoyCaptain
  module Ahoy
    module VisitMethods
      extend ActiveSupport::Concern

      included do
        ransacker :ref_domain do
          Arel.sql("(substring(referring_domain from '(?:.*://)?(?:www\.)?([^/?]*)'))")
        end
      end

      class_methods do
        def ransackable_attributes(auth = nil)
          columns_hash.keys + ["ref_domain"]
        end


        def ransackable_attributes(auth = nil)
          columns_hash.keys + ["ref_domain"]
        end
      end
    end
  end
end
