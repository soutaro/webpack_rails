$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "webpack_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "webpack_rails"
  s.version     = WebpackRails::VERSION
  s.authors     = ["Soutaro Matsumoto"]
  s.email       = ["matsumoto@soutaro.com"]
  s.homepage    = "https://github.com/soutaro/webpack_rails"
  s.summary     = "Webpack integration for Rails"
  s.description = "Webpack integration for Rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "tilt", "~> 2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "coffee-rails"
end
