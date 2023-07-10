require_relative "lib/mo_config/version"

Gem::Specification.new do |spec|
  spec.name        = "mo_config"
  spec.version     = MoConfig::VERSION
  spec.authors     = ["Adam Akhtar"]
  spec.email       = ["adamsubscribe@googlemail.com"]
  spec.homepage    = "https://github.com/adamakhtar/mo_config"
  spec.summary     = "A better way to organize your Rails app's config"
  spec.description = "A better way to organize your Rails app's config"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.5"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "minitest-focus"
end
