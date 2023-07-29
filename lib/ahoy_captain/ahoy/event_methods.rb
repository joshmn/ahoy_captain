module AhoyCaptain
  module Ahoy
    module EventMethods
      extend ActiveSupport::Concern

      included do
        scope :with_routes, -> { where(AhoyCaptain.config.event[:url_exists]) }

        ransacker :route do |_parent|
          Arel.sql(captain_url_signature)
        end
      end

      class_methods do
        def ransackable_attributes(auth_object = nil)
          ["action", "controller", "id", "id_property", "name", "name_property", "page", "properties", "route", "time", "url", "user_id", "visit_id"]
        end
      end
    end
  end
end

