# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    module Extension
      def self.included(klass)
        klass.before_action do
          @mailing = Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY] if Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY]
        end
      end
    end
  end
end
