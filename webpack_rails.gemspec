$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "webpack_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "webpack_rails"
  s.version     = WebpackRails::VERSION
  s.authors     = ["Soutaro Matsumoto"]
  s.email       = ["matsumoto@soutaro.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of WebpackRails."
  s.description = "TODO: Description of WebpackRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "tilt", "~> 2.0"

  s.add_development_dependency "sqlite3"
end
