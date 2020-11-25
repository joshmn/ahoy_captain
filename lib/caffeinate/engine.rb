require "caffeinate/action_mailer"

module Caffeinate
  # @private
  class Engine < ::Rails::Engine
    isolate_namespace Caffeinate

    ActiveSupport.on_load(:action_mailer) do
      include ::Caffeinate::ActionMailer::Extension
      ::ActionMailer::Base.register_interceptor(::Caffeinate::ActionMailer::Interceptor)
      ::ActionMailer::Base.register_observer(::Caffeinate::ActionMailer::Observer)
    end
  end
end
