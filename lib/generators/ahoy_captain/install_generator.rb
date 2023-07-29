require "rails/generators"

module AhoyCaptain
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.join(__dir__, "templates")

      def copy_templates
        insert_into_file ::Rails.root.join("app/models/ahoy/event.rb").to_s, "  include AhoyCaptain::Ahoy::EventMethods\n", after: "class Ahoy::Event < ApplicationRecord\n"
        insert_into_file ::Rails.root.join("app/models/ahoy/visit.rb").to_s, "  include AhoyCaptain::Ahoy::VisitMethods\n", after: "class Ahoy::Visit < ApplicationRecord\n"

        template "config.rb", "config/initializers/ahoy_captain.rb"

        route "mount AhoyCaptain::Engine => '/ahoy_captain'"
      end
    end
  end
end
