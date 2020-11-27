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
        run_callbacks(:before_process, self)
        campaign.caffeinate_campaign_subscriptions.active.in_batches(of: self.class._batch_size).each do |batch|
          run_callbacks(:on_process, self, batch)
          batch.each do |subscriber|
            if subscriber.next_caffeinate_mailing
              subscriber.next_caffeinate_mailing.process!
            end
          end
        end
        run_callbacks(:after_process, self)
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
