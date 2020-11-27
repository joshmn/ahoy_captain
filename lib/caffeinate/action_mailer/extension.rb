# frozen_string_literal: true

module Caffeinate
  module ActionMailer
    module Extension
      def self.included(klass)
        klass.before_action do
          @mailing = Thread.current[:current_caffeinate_mailing] if Thread.current[:current_caffeinate_mailing]
        end
      end
    end
  end
end
