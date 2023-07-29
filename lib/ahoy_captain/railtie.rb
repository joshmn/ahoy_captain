module AhoyCaptain
  class Railtie < ::Rails::Railtie
    initializer "ahoy_captain.assets.precompile" do |app|
      app.config.assets.precompile += %w[ahoy_captain/manifest]
    end
  end
end
