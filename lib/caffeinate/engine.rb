# frozen_string_literal: true

require 'caffeinate/action_mailer'
require 'caffeinate/active_record/extension'

module Caffeinate
  # :nodoc:
  class Engine < ::Rails::Engine
    isolate_namespace Caffeinate

    Rails.application.reloader.to_prepare do
      Dir.glob(Rails.root.join("app/drippers/**/*.rb")).each do |file|
        load file
      end
    end

    ActiveSupport.on_load(:action_mailer) do
      include ::Caffeinate::ActionMailer::Extension
      ::ActionMailer::Base.register_interceptor(::Caffeinate::ActionMailer::Interceptor)
      ::ActionMailer::Base.register_observer(::Caffeinate::ActionMailer::Observer)
    end

    ActiveSupport.on_load(:active_record) do
      extend ::Caffeinate::ActiveRecord::Extension
    end
  end
end
