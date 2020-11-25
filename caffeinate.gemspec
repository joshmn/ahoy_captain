$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "caffeinate/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "caffeinate"
  spec.version     = Caffeinate::VERSION
  spec.authors     = ["Josh Brody"]
  spec.email       = ["josh@josh.mn"]
  spec.homepage    = "https://github.com/joshmn/caffeinate"
  spec.summary     = "Opinionated drip campaign framework."
  spec.description = spec.summary
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.4"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "timecop"
end
