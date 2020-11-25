require 'caffeinate/campaign_mailer/drip'
require 'caffeinate/campaign_mailer/callbacks'
require 'caffeinate/campaign_mailer/defaults'
require 'caffeinate/campaign_mailer/subscriber'
require 'caffeinate/campaign_mailer/campaign'
require 'caffeinate/campaign_mailer/perform'
require 'caffeinate/campaign_mailer/delivery'

module Caffeinate
  module CampaignMailer
    class Base
      include Callbacks
      include Campaign
      include Defaults
      include Delivery
      include Drip
      include Perform
      include Subscriber
    end
  end
end
