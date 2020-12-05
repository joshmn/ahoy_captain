# frozen_string_literal: true

module Caffeinate
  module Generators
    # Installs Caffeinate
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      include ::Rails::Generators::Migration

      desc 'Creates a Caffeinate initializer and copies migrations to your application.'

      # :nodoc:
      def copy_initializer
        template 'caffeinate.rb', 'config/initializers/caffeinate.rb'
      end

      # :nodoc:
      def copy_application_campaign
        template 'application_dripper.rb', 'app/drippers/application_dripper.rb'
      end

      def install_routes
        inject_into_file 'config/routes.rb', "\n  mount ::Caffeinate::Engine => '/caffeinate'", after: /Rails.application.routes.draw do/
      end

      # :nodoc:
      def self.next_migration_number(_path)
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        end
        @prev_migration_nr.to_s
      end

      # :nodoc:
      def copy_migrations
        require 'rake'
        Rails.application.load_tasks
        Rake::Task['railties:install:migrations'].reenable
        Rake::Task['caffeinate:install:migrations'].invoke
      end
    end
  end
end
