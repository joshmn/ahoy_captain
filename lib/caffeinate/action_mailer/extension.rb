module Caffeinate
  module ActionMailer
    module Extension
      def self.included(klass)
        klass.before_action do
          if Thread.current[:current_caffeinate_mailing]
            @mailing = Thread.current[:current_caffeinate_mailing]
          end
        end
      end
    end
  end
end
