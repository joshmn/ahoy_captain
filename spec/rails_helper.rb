# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'bundler/setup'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'factory_bot'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

puts "bundle exec rspec --seed #{RSpec.configuration.seed}"
Rails.application.routes.default_url_options[:host] = 'localhost:3000'
