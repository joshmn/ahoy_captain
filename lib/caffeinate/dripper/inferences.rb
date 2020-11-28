# frozen_string_literal: true

module Caffeinate
  module Dripper
    module Inferences
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # The inferred mailer class
        def inferred_mailer_class
          klass_name = "#{name.delete_suffix('Dripper')}Mailer"
          klass = klass_name.safe_constantize
          return nil unless klass
          return klass_name if klass < ::ActionMailer::Base

          nil
        end

        # The inferred mailer class
        def inferred_campaign_slug
          name.delete_suffix('Dripper').to_s.underscore
        end
      end
    end
  end
end
