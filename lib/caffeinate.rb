require 'rails/all'
require "caffeinate/engine"
require "caffeinate/drip"
require "caffeinate/campaign_mailer/base"

module Caffeinate
  def self.campaign_mailer_to_campaign_class
    @campaign_slug_to_campaign_class ||= {}
  end

  def self.register_campaign_mailer(name, klass)
    campaign_mailer_to_campaign_class[name.to_sym] = klass
  end
end
