require 'ahoy'
require 'turbo-rails'
require 'stimulus-rails'
require 'ransack'
require 'view_component'
require 'chartkick'
require 'groupdate'
require 'pagy'

module AhoyCaptain
  class Engine < Rails::Engine
    isolate_namespace ::AhoyCaptain

    initializer "ahoy_captain.precompile" do |app|
      app.config.assets.paths << AhoyCaptain::Engine.root.join("app/javascript")
      app.config.assets.paths << AhoyCaptain::Engine.root.join("app/images")
      app.config.assets.precompile << "ahoy_captain/application.js"
    end
  end
end
