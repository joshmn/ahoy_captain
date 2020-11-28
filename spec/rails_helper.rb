# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'bundler/setup'

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
# Add additional requires below this line. Rails is not loaded until this point!
require 'rspec/rails'
require 'factory_bot'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
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
  config.before(:each) do
    Thread.current[::Caffeinate::Mailing::CURRENT_THREAD_KEY] = nil
  end
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

ActiveJob::Base.queue_adapter = :test
Rails.application.routes.default_url_options[:host] = 'localhost:3000'

class BaseTestDripper < ::Caffeinate::Dripper::Base; end
class ArgumentMailer < ActionMailer::Base
  def hello(mailing)
    mail(to: "argument_mailer@example.com", from: "argument_mailer@example.com", subject: "Argument Mailer") do |format|
      format.text { render plain: "ArgumentMailer" }
    end
  end
end

# Silence warnings, namely warning: class variable access from toplevel in observer_spec and interceptor_spec
$VERBOSE = nil
