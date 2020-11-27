# frozen_string_literal: true

require 'caffeinate/dripper/drip'
require 'caffeinate/dripper/callbacks'
require 'caffeinate/dripper/defaults'
require 'caffeinate/dripper/subscriber'
require 'caffeinate/dripper/campaign'
require 'caffeinate/dripper/perform'
require 'caffeinate/dripper/delivery'

module Caffeinate
  module Dripper
    class Base
      include Callbacks
      include Campaign
      include Defaults
      include Delivery
      include Drip
      include Perform
      include Subscriber

      # The inferred mailer class
      def self.inferred_mailer_class
        klass_name = "#{name.delete_suffix('Dripper')}Mailer"
        klass = klass_name.safe_constantize
        return nil unless klass
        return klass_name if klass < ::ActionMailer::Base

        nil
      end
    end
  end
end
