class Ahoy::Event < ApplicationRecord
  include AhoyCaptain::Ahoy::EventMethods
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

  def self.captain_url_signature
    "CONCAT(properties->>'controller', '#', properties->>'action')"
  end

  def self.captain_url_exists
    "JSONB_EXISTS(properties, 'controller') AND JSONB_EXISTS(properties, 'action')"
  end
end
