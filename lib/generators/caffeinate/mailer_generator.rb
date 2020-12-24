# frozen_string_literal: true

module Caffeinate
  module Generators
    # Creates a mailer from a dripper.
    class MailerGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      include ::Rails::Generators::Migration
      argument :dripper, banner: "dripper"

      desc 'Creates a Mailer class from a dripper.'

      def create_mailer
        @dripper_klass = @dripper.safe_constantize
        if @dripper_klass.nil?
          raise ArgumentError, "Unknown dripper #{@dripper}"
        end
        @mailer_class = @dripper_klass.defaults[:mailer_class] || @dripper_klass.defaults[:mailer]
        template 'mailer.rb', "app/mailers/#{@mailer_class.underscore}.rb"
      end

    end
  end
end
