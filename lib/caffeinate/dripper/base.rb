# frozen_string_literal: true

require 'caffeinate/dripper/batching'
require 'caffeinate/dripper/callbacks'
require 'caffeinate/dripper/campaign'
require 'caffeinate/dripper/defaults'
require 'caffeinate/dripper/delivery'
require 'caffeinate/dripper/drip'
require 'caffeinate/dripper/inferences'
require 'caffeinate/dripper/perform'
require 'caffeinate/dripper/subscriber'

module Caffeinate
  module Dripper
    # Base class
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
