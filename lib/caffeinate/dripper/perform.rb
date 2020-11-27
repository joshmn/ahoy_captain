# frozen_string_literal: true

module Caffeinate
  module Dripper
    # Handles delivering a `Caffeinate::Mailing` for the `Caffeinate::Dripper`
    module Perform
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      # Delivers the next_caffeinate_mailer for the campaign's subscribers.
      #
      #   OrderDripper.new.perform!
      #
      # @return nil
      def perform!
        campaign.caffeinate_campaign_subscriptions.active.includes(:next_caffeinate_mailing).each do |subscriber|
          if subscriber.next_caffeinate_mailing
           subscriber.next_caffeinate_mailing.process!
          end
        end
        true
      end

      module ClassMethods
        # Convenience method for Dripper::Base#perform
        def perform!
          new.perform!
        end
      end
    end
  end
end
