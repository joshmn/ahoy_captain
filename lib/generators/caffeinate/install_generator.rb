module Moist
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      include ::Rails::Generators::Migration

      desc "Creates a Caffeinate initializer and copies migrations to your application."

      def copy_initializer
        template "caffeinate.rb", "config/initializers/caffeinate.rb"
      end

      def self.next_migration_number(_path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        require 'rake'
        Rails.application.load_tasks
        Rake::Task['railties:install:migrations'].reenable
        Rake::Task['caffeinate:install:migrations'].invoke
      end

    end
  end
end
