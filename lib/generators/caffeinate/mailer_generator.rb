# frozen_string_literal: true

module Caffeinate
  module Generators
    # Installs Caffeinate
    class MailerGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      include ::Rails::Generators::Migration
      argument :dripper, banner: "Dripper class"

      desc 'Creates a Mailer class from a dripper.'

      def create_mailer
        template 'mailer.rb', 'app/mailers/application_dripper.rb'
      end

    end
  end
end
