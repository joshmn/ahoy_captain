# frozen_string_literal: true

module Caffeinate
  module Generators
    # Creates a mailer from a dripper.
    class DripperGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      include ::Rails::Generators::Migration
      argument :name, banner: "name"
      argument :skip_mailer, banner: "skip mailer"

      desc 'Creates a Dripper from the given name, and optional mailer.'

      def create_mailer
        template 'dripper.rb', "app/mailers/#{@mailer_class.underscore}.rb"
      end

    end
  end
end
