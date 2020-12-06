# frozen_string_literal: true

module Caffeinate
  module Dripper
    # Handles delivering a `Caffeinate::Mailing` for the `Caffeinate::Dripper`.
    module Perform
      # :nodoc:
      def self.included(klass)
        klass.extend ClassMethods
      end

      # Delivers the next_caffeinate_mailer for the campaign's subscribers. Handles with batches based on `batch_size`.
      #
      #   OrderDripper.new.perform!
      #
      # @return nil
      def perform!
        includes = [:next_caffeinate_mailing]
        preloads = []
        if ::Caffeinate.config.async_delivery?
          # nothing
        else
          preloads += %i[subscriber user]
        end

        run_callbacks(:before_perform, self)
        campaign.caffeinate_campaign_subscriptions
                .active
                .joins(:next_caffeinate_mailing)
                .preload(*preloads)
                .includes(*includes)
                .in_batches(of: self.class.batch_size)
                .each do |batch|
          run_callbacks(:on_perform, self, batch)
          batch.each do |subscriber|
            subscriber.next_caffeinate_mailing.process!
          end
        end
        run_callbacks(:after_perform, self)
        nil
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
