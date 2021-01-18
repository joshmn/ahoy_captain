# frozen_string_literal: true

module Caffeinate
  module Generators
    # Installs Caffeinate
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

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

      def migration_version
        if rails5_and_up?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end

      # :nodoc:
      def copy_migrations
        template 'migrations/create_caffeinate_campaigns.rb', "db/migrate/#{self.class.next_migration_number("")}_create_caffeinate_campaigns.rb"
        template 'migrations/create_caffeinate_campaign_subscriptions.rb', "db/migrate/#{self.class.next_migration_number("")}_create_caffeinate_campaign_subscriptions.rb"
        template 'migrations/create_caffeinate_mailings.rb', "db/migrate/#{self.class.next_migration_number("")}_create_caffeinate_mailings.rb"
      end
    end
  end
end
