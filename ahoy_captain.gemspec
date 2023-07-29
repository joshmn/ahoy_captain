require_relative "lib/ahoy_captain/version"

Gem::Specification.new do |spec|
  spec.name        = "ahoy_captain"
  spec.version     = AhoyCaptain::VERSION
  spec.authors     = ["joshmn"]
  spec.homepage    = spec.metadata["homepage_uri"]
  spec.summary     = "A full-featured, mountable analytics dashboard for your Rails app."
  spec.description = spec.summary
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = "https://github.com/joshmn/ahoy_captain"
  spec.metadata["source_code_uri"] = spec.metadata["homepage_uri"]
  spec.metadata["changelog_uri"] = spec.metadata["homepage_uri"]

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6"
  spec.add_dependency "ransack", ">= 3.0"
  spec.add_dependency "turbo-rails", ">= 1.2"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "importmap-rails", ">= 1"
  spec.add_dependency "stimulus-rails", ">= 1.1"
  spec.add_dependency "ahoy_matey", ">= 1.1"
  spec.add_dependency "chartkick", ">= 4"
  spec.add_dependency "groupdate", ">= 5"

  spec.add_development_dependency "rails", ">= 6"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "better_errors"
  spec.add_development_dependency "binding_of_caller"
  spec.add_development_dependency "sassc"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "lol_dba"
end
