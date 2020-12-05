# frozen_string_literal: true

require 'caffeinate/helpers'
require 'caffeinate/action_mailer'
require 'caffeinate/active_record/extension'

module Caffeinate
  # Adds Caffeinate to Rails
  class Engine < ::Rails::Engine
    isolate_namespace Caffeinate
    config.eager_load_namespaces << Caffeinate

    ActiveSupport.on_load(:action_mailer) do
      include ::Caffeinate::ActionMailer::Extension
      ::ActionMailer::Base.register_interceptor(::Caffeinate::ActionMailer::Interceptor)
      ::ActionMailer::Base.register_observer(::Caffeinate::ActionMailer::Observer)
    end

    ActiveSupport.on_load(:active_record) do
      extend ::Caffeinate::ActiveRecord::Extension
    end

    ActiveSupport.on_load(:action_view) do
      ActionView::Base.include ::Caffeinate::Helpers
    end
  end
end
