# frozen_string_literal: true

require 'rails/all'
require 'caffeinate/engine'
require 'caffeinate/drip'
require 'caffeinate/configuration'
require 'caffeinate/campaign_mailer/base'

module Caffeinate
  # Caches the campaign to the campaign class
  def self.campaign_mailer_to_campaign_class
    @campaign_slug_to_campaign_class ||= {}
  end

  # Convenience method for `campaign_mailer_to_campaign_class`
  def self.register_campaign_mailer(name, klass)
    campaign_mailer_to_campaign_class[name.to_sym] = klass
  end

  # Global configuration
  def self.config
    @config ||= Configuration.new
  end

  # Yields the configuration
  def self.setup
    yield config
  end
end
