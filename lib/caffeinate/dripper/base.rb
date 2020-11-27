# frozen_string_literal: true

require 'caffeinate/dripper/drip'
require 'caffeinate/dripper/batching'
require 'caffeinate/dripper/inferences'
require 'caffeinate/dripper/callbacks'
require 'caffeinate/dripper/defaults'
require 'caffeinate/dripper/subscriber'
require 'caffeinate/dripper/campaign'
require 'caffeinate/dripper/perform'
require 'caffeinate/dripper/delivery'

module Caffeinate
  module Dripper
    class Base
      include Batching
      include Callbacks
      include Campaign
      include Defaults
      include Delivery
      include Drip
      include Inferences
      include Perform
      include Subscriber
    end
  end
end
