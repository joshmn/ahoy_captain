# frozen_string_literal: true

require 'caffeinate/dripper/batching'
require 'caffeinate/dripper/callbacks'
require 'caffeinate/dripper/campaign'
require 'caffeinate/dripper/defaults'
require 'caffeinate/dripper/delivery'
require 'caffeinate/dripper/drip'
require 'caffeinate/dripper/inferences'
require 'caffeinate/dripper/perform'
require 'caffeinate/dripper/periodical'
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
      include Periodical
      include Subscriber
    end
  end
end

ActiveSupport.run_load_hooks :caffeinate, Caffeinate::Dripper::Base
