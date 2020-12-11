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
        run_callbacks(:before_perform, self)
        Caffeinate::Mailing
          .upcoming
          .unsent
          .joins(:caffeinate_campaign_subscription)
          .merge(Caffeinate::CampaignSubscription.active)
          .in_batches(of: self.class.batch_size)
          .each do |batch|
          run_callbacks(:on_perform, self, batch)
          batch.each do |mailing|
            mailing.process!
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
