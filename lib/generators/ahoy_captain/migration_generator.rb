require "rails/generators"
require "rails/generators/active_record"

module AhoyCaptain
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration
      source_root File.join(__dir__, "templates")

      def copy_templates
        migration_template "migration.rb", "db/migrate/create_ahoy_captain_indexes.rb", migration_version: migration_version
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end
  end
end
