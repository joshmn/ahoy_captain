# frozen_string_literal: true

require 'rails/all'
require 'caffeinate/engine'
require 'caffeinate/drip'
require 'caffeinate/url_helpers'
require 'caffeinate/configuration'
require 'caffeinate/dripper/base'
require 'caffeinate/deliver_async'

module Caffeinate
  # Caches the campaign to the campaign class
  def self.dripper_to_campaign_class
    @dripper_to_campaign_class ||= {}
  end

  # Convenience method for `dripper_to_campaign_class`
  def self.register_dripper(name, klass)
    dripper_to_campaign_class[name.to_sym] = klass
  end

  # Global configuration
  def self.config
    @config ||= Configuration.new
  end

  # Yields the configuration
  def self.setup
    yield config
  end

  def self.current_mailing=(val)
    Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY] = val
  end

  def self.current_mailing
    Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY]
  end
end
